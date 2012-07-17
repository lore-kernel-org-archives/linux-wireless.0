Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:49864 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751960Ab2GQM5h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jul 2012 08:57:37 -0400
Message-ID: <5005613F.1000004@net.t-labs.tu-berlin.de> (sfid-20120717_145741_026234_DCAC3108)
Date: Tue, 17 Jul 2012 14:57:35 +0200
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: coelho@ti.com, brcm80211-dev-list@broadcom.com,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, users@rt2x00.serialmonkey.com,
	ilw@linux.intel.com, ath9k-devel@lists.ath9k.org,
	b43-dev@lists.infradead.org, chunkeey@googlemail.com,
	dsd@gentoo.org, buytenh@wantstofly.org
Subject: Re: [ath5k-devel] [PATCH 2/2] mac80211: Remove control.sta from struct
 ieee80211_tx_info and restructure tx-path
References: <1342205545-45382-1-git-send-email-thomas@net.t-labs.tu-berlin.de> <1342205545-45382-3-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20120713_205245_114771_49FF4AC7) <1342518290.7427.9.camel@jlt3.sipsolutions.net>
In-Reply-To: <1342518290.7427.9.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

Johannes Berg schrieb:
> Ok first of all, please actually compile the tree after your changes. It
> doesn't. When it does, please fix

I always do compile the compat-wireless-tree after changes I introduce,
and it compiles without errors in the case of this mac80211:sta-remove
patch. But as my build tree is based on the OpenWrt environment, it
might be not 100% in sync. Could you be a bit more explicit where does
it brake in you case (which function, driver...) ?

>  1) line length in the commit log should be < 72 chars

Will do so in v2.

>  3) removal of an important comment in mac80211.h that I pointed out in
>     previous review

>From your previous review:"...btw, you lost an important comment about
it being NULL along the way"
I guess you refer to the comment in mac80211.h, struct tx_info that I
removed:
- * The TX control's sta pointer is only valid during the ->tx call,
- * it may be NULL.

I am not sure what you want me to keep here as comment. As the sta
pointer is moved into the new struct tx_control and the remaining
pointers in the tx_info->control structure (vif, hw_key) are ALL only
valid during the ->tx call and may be NULL. So I could think of adding a
comment to tx_control about the sta been NULL, but anything more ?


>> The tx-path of all affected drivers is restructured to respect the
chaneged
>> layout of struct ieee80211_tx_info. List of modified drivers:
>> ath9k
>
> Please also remove the driver list. git can tell you the modified files
> very easily.

Will do so in v2.

Greetings Thomas
