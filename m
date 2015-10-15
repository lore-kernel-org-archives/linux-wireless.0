Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from postler.einfach.org ([5.9.2.179]:47474 "EHLO
	postler.einfach.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbbJOMRd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2015 08:17:33 -0400
Subject: Re: [PATCH 1/1] New driver: rtl8xxxu (mac80211)
To: Jes.Sorensen@redhat.com, kvalo@codeaurora.org
References: <1444869891-21174-1-git-send-email-Jes.Sorensen@redhat.com>
 <1444869891-21174-2-git-send-email-Jes.Sorensen@redhat.com>
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net
From: Bruno Randolf <br1@einfach.org>
Message-ID: <561F978F.8080408@einfach.org> (sfid-20151015_141739_282517_63032157)
Date: Thu, 15 Oct 2015 13:09:51 +0100
MIME-Version: 1.0
In-Reply-To: <1444869891-21174-2-git-send-email-Jes.Sorensen@redhat.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jens,

I just tested your driver with a RTL8188CU rev A ("Vilros" ID 0bda:8176)
and it works well so far! I'm missing monitor mode however. Do you see
any chance to add that?

Your patch seems to be correct, but in your own git, branch
'rtl8723au-mac80211' you seem to be missing the below part:

On 10/15/2015 01:44 AM, Jes.Sorensen@redhat.com wrote:
> --- a/drivers/net/wireless/realtek/Makefile
> +++ b/drivers/net/wireless/realtek/Makefile
> @@ -5,4 +5,5 @@
>  obj-$(CONFIG_RTL8180)		+= rtl818x/
>  obj-$(CONFIG_RTL8187)		+= rtl818x/
>  obj-$(CONFIG_RTLWIFI)		+= rtlwifi/
> +obj-$(CONFIG_RTL8XXXU)		+= rtl8xxxu/

And it has that leftover in drivers/net/wireless/Makefile:

obj-$(CONFIG_RTL8XXXU) += rtl8xxxu.o

I had to add the following change to my local tree in order to be able
to build:

diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
index bc44950..740fdd3 100644
--- a/drivers/net/wireless/Makefile
+++ b/drivers/net/wireless/Makefile
@@ -37,8 +37,6 @@ obj-$(CONFIG_LIBERTAS_THINFIRM)       += libertas_tf/

 obj-$(CONFIG_ADM8211)  += adm8211.o

-obj-$(CONFIG_RTL8XXXU) += rtl8xxxu.o
-
 obj-$(CONFIG_MWL8K)    += mwl8k.o

 obj-$(CONFIG_IWLWIFI)  += iwlwifi/
diff --git a/drivers/net/wireless/realtek/Makefile
b/drivers/net/wireless/realtek/Makefile
index 3489b98..9c78deb 100644
--- a/drivers/net/wireless/realtek/Makefile
+++ b/drivers/net/wireless/realtek/Makefile
@@ -5,4 +5,5 @@
 obj-$(CONFIG_RTL8180)          += rtl818x/
 obj-$(CONFIG_RTL8187)          += rtl818x/
 obj-$(CONFIG_RTLWIFI)          += rtlwifi/
+obj-$(CONFIG_RTL8XXXU)         += rtl8xxxu/

Greetings,
bruno
