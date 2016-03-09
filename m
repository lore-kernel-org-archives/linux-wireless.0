Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mleia.com ([178.79.152.223]:52408 "EHLO mail.mleia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964797AbcCIXaj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2016 18:30:39 -0500
Subject: Re: [PATCH] staging: wilc1000: fix check of kthread_run() return
 value
To: Julian Calaby <julian.calaby@gmail.com>
References: <1457565194-31533-1-git-send-email-vz@mleia.com>
 <CAGRGNgUMViiR+ruvLHnwMLHUxOK3+uW7634Hpgn9gN+djCOtbw@mail.gmail.com>
Cc: Glen Lee <glen.lee@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Leo Kim <leo.kim@atmel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
From: Vladimir Zapolskiy <vz@mleia.com>
Message-ID: <56E0B21D.1010503@mleia.com> (sfid-20160310_003047_459161_B5A4342F)
Date: Thu, 10 Mar 2016 01:30:37 +0200
MIME-Version: 1.0
In-Reply-To: <CAGRGNgUMViiR+ruvLHnwMLHUxOK3+uW7634Hpgn9gN+djCOtbw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Julian,

On 10.03.2016 01:27, Julian Calaby wrote:
> Hi Vladimir,
> 
> On Thu, Mar 10, 2016 at 10:13 AM, Vladimir Zapolskiy <vz@mleia.com> wrote:
>> The kthread_run() function returns either a valid task_struct or
>> ERR_PTR() value, check for NULL is invalid. The change fixes potential
>> oops, e.g. in OOM situation.
>>
>> Signed-off-by: Vladimir Zapolskiy <vz@mleia.com>
>> ---
>>  drivers/staging/wilc1000/linux_wlan.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
>> index 54fe9d7..5077c30 100644
>> --- a/drivers/staging/wilc1000/linux_wlan.c
>> +++ b/drivers/staging/wilc1000/linux_wlan.c
>> @@ -849,10 +849,10 @@ static int wlan_initialize_threads(struct net_device *dev)
>>         PRINT_D(INIT_DBG, "Creating kthread for transmission\n");
>>         wilc->txq_thread = kthread_run(linux_wlan_txq_task, (void *)dev,
>>                                      "K_TXQ_TASK");
>> -       if (!wilc->txq_thread) {
>> +       if (IS_ERR(wilc->txq_thread)) {
>>                 PRINT_ER("couldn't create TXQ thread\n");
>>                 wilc->close = 0;
>> -               return -ENOBUFS;
>> +               return PTR_ERR(wilc->txq_thread);
> 
> Are you sure changing the error returned is correct? Do all the
> callers of wlan_initialize_threads() handle the full range of errors
> from kthread_run()?

Have you checked the driver?

This function is called once on initialization, the check on the upper layer
has "if (ret < 0) goto exit_badly;" form.

--
With best wishes,
Vladimir
