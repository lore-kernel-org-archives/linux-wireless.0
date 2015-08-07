Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:35226 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778AbbHGASz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2015 20:18:55 -0400
Received: by igr7 with SMTP id 7so21809312igr.0
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2015 17:18:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1438905724-26810-1-git-send-email-chaehyun.lim@gmail.com>
References: <1438905724-26810-1-git-send-email-chaehyun.lim@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 7 Aug 2015 10:18:35 +1000
Message-ID: <CAGRGNgXsVBFbx+O3NW+7Sok1nbzziPeHa0ONSeviqXhFGQ2GPA@mail.gmail.com> (sfid-20150807_021858_896787_165DD0EB)
Subject: Re: [PATCH 1/4] staging: wilc1000: use memset instead of WILC_memset
To: Chaehyun Lim <chaehyun.lim@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
	Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Chaehyun,

On Fri, Aug 7, 2015 at 10:02 AM, Chaehyun Lim <chaehyun.lim@gmail.com> wrote:
> Use memset instead of WILC_memset.
>
> Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
> ---
>  drivers/staging/wilc1000/coreconfigurator.c       |  16 +--
>  drivers/staging/wilc1000/host_interface.c         | 134 +++++++++++-----------
>  drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  16 +--
>  3 files changed, 83 insertions(+), 83 deletions(-)
>
> diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
> index 342a336..93942b2 100644
> --- a/drivers/staging/wilc1000/coreconfigurator.c
> +++ b/drivers/staging/wilc1000/coreconfigurator.c
> @@ -681,9 +681,9 @@ s32 CoreConfiguratorInit(void)
>                 goto _fail_;
>         }
>
> -       WILC_memset((void *)gps8ConfigPacket, 0, MAX_PACKET_BUFF_SIZE);
> +       memset((void *)gps8ConfigPacket, 0, MAX_PACKET_BUFF_SIZE);

I believe you can get rid of these void* casts, you're modifying the
line anyway.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
