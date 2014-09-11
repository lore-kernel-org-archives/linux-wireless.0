Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:45920 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbaIKKj6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2014 06:39:58 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v4 2/2] ath10k: add testmode
References: <20140910152136.12610.18499.stgit@potku.adurom.net>
	<20140910152329.12610.41409.stgit@potku.adurom.net>
	<CA+BoTQkBiKPzHBfTA2xpmgbUbutSj5Z6w6gP7EO6aotacM5_cA@mail.gmail.com>
Date: Thu, 11 Sep 2014 13:39:41 +0300
In-Reply-To: <CA+BoTQkBiKPzHBfTA2xpmgbUbutSj5Z6w6gP7EO6aotacM5_cA@mail.gmail.com>
	(Michal Kazior's message of "Thu, 11 Sep 2014 11:47:34 +0200")
Message-ID: <87ppf230gi.fsf@kamboji.qca.qualcomm.com> (sfid-20140911_124002_234959_7611B7A4)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 10 September 2014 17:23, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> [...]
>
> Just a small nitpick:
>
>> +static int ath10k_tm_cmd_utf_stop(struct ath10k *ar, struct nlattr *tb[])
>> +{
>> +       int ret;
>> +
>> +       ath10k_dbg(ar, ATH10K_DBG_TESTMODE, "testmode cmd utf stop\n");
>> +
>> +       mutex_lock(&ar->conf_mutex);
>> +
>> +       if (ar->state != ATH10K_STATE_UTF) {
>> +               ret = -ENETDOWN;
>> +               goto out;
>> +       }
>> +
>> +       __ath10k_tm_cmd_utf_stop(ar);
>> +
>> +       ar->state = ATH10K_STATE_OFF; // <-- this
>
> I would move it to __ath10k_tm_cmd_utf_stop() itself so that the state
> is reset in ath10k_testmode_destroy() as well.

Ok. It doesn't make any difference on the functionality, but I'll change
it anyway. I folded this patch to the commit:

diff --git a/drivers/net/wireless/ath/ath10k/testmode.c b/drivers/net/wireless/ath/ath10k/testmode.c
index 9d77d72042ff..483db9cb8c96 100644
--- a/drivers/net/wireless/ath/ath10k/testmode.c
+++ b/drivers/net/wireless/ath/ath10k/testmode.c
@@ -253,6 +253,8 @@ static void __ath10k_tm_cmd_utf_stop(struct ath10k *ar)
 
        release_firmware(ar->testmode.utf);
        ar->testmode.utf = NULL;
+
+       ar->state = ATH10K_STATE_OFF;
 }
 
 static int ath10k_tm_cmd_utf_stop(struct ath10k *ar, struct nlattr *tb[])
@@ -270,7 +272,6 @@ static int ath10k_tm_cmd_utf_stop(struct ath10k *ar, struct nlattr *tb[])
 
        __ath10k_tm_cmd_utf_stop(ar);
 
-       ar->state = ATH10K_STATE_OFF;
        ret = 0;
 
        ath10k_info(ar, "UTF firmware stopped\n");

-- 
Kalle Valo
