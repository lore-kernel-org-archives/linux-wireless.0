Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48315 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753369AbbJOMQi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2015 08:16:38 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Bruno Randolf <br1@einfach.org>
Cc: kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
	Larry.Finger@lwfinger.net
Subject: Re: [PATCH 1/1] New driver: rtl8xxxu (mac80211)
References: <1444869891-21174-1-git-send-email-Jes.Sorensen@redhat.com>
	<1444869891-21174-2-git-send-email-Jes.Sorensen@redhat.com>
	<561F978F.8080408@einfach.org>
Date: Thu, 15 Oct 2015 08:16:36 -0400
In-Reply-To: <561F978F.8080408@einfach.org> (Bruno Randolf's message of "Thu,
	15 Oct 2015 13:09:51 +0100")
Message-ID: <wrfjd1wg5ntn.fsf@redhat.com> (sfid-20151015_141643_203420_64B64E2F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bruno Randolf <br1@einfach.org> writes:
> Hi Jens,

Jes :)

> I just tested your driver with a RTL8188CU rev A ("Vilros" ID 0bda:8176)
> and it works well so far! I'm missing monitor mode however. Do you see
> any chance to add that?

It's on the todo list, but fairly far down the list. I am more focused
on adding support for more devices and features at this point.

> Your patch seems to be correct, but in your own git, branch
> 'rtl8723au-mac80211' you seem to be missing the below part:
>
> On 10/15/2015 01:44 AM, Jes.Sorensen@redhat.com wrote:
>> --- a/drivers/net/wireless/realtek/Makefile
>> +++ b/drivers/net/wireless/realtek/Makefile
>> @@ -5,4 +5,5 @@
>>  obj-$(CONFIG_RTL8180)		+= rtl818x/
>>  obj-$(CONFIG_RTL8187)		+= rtl818x/
>>  obj-$(CONFIG_RTLWIFI)		+= rtlwifi/
>> +obj-$(CONFIG_RTL8XXXU)		+= rtl8xxxu/
>
> And it has that leftover in drivers/net/wireless/Makefile:
>
> obj-$(CONFIG_RTL8XXXU) += rtl8xxxu.o
>
> I had to add the following change to my local tree in order to be able
> to build:
>
> diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
> index bc44950..740fdd3 100644
> --- a/drivers/net/wireless/Makefile
> +++ b/drivers/net/wireless/Makefile
> @@ -37,8 +37,6 @@ obj-$(CONFIG_LIBERTAS_THINFIRM)       += libertas_tf/
>
>  obj-$(CONFIG_ADM8211)  += adm8211.o
>
> -obj-$(CONFIG_RTL8XXXU) += rtl8xxxu.o
> -
>  obj-$(CONFIG_MWL8K)    += mwl8k.o
>
>  obj-$(CONFIG_IWLWIFI)  += iwlwifi/
> diff --git a/drivers/net/wireless/realtek/Makefile
> b/drivers/net/wireless/realtek/Makefile
> index 3489b98..9c78deb 100644
> --- a/drivers/net/wireless/realtek/Makefile
> +++ b/drivers/net/wireless/realtek/Makefile
> @@ -5,4 +5,5 @@
>  obj-$(CONFIG_RTL8180)          += rtl818x/
>  obj-$(CONFIG_RTL8187)          += rtl818x/
>  obj-$(CONFIG_RTLWIFI)          += rtlwifi/
> +obj-$(CONFIG_RTL8XXXU)         += rtl8xxxu/

Thanks, I already fixed this, but I may have forgotten to git push
it. Let me fix that.

Thanks for testing, I am pleased to hear it works well for you!

Cheers,
Jes
