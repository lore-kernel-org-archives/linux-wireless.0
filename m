Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:33411 "EHLO
	mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbcFQE7o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jun 2016 00:59:44 -0400
MIME-Version: 1.0
In-Reply-To: <877fdpw4no.fsf@kamboji.qca.qualcomm.com>
References: <1464378815-23282-1-git-send-email-zajec5@gmail.com> <877fdpw4no.fsf@kamboji.qca.qualcomm.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Fri, 17 Jun 2016 06:59:42 +0200
Message-ID: <CACna6rzXzj4DJNA6855Qy6QnxETnYEPmqtw3Bcx8WWCtYwYvuw@mail.gmail.com> (sfid-20160617_070022_103830_6A6956CE)
Subject: Re: [PATCH 4.7 FIX] brcmfmac: fix lockup when removing P2P interface
 after event timeout
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	Franky Lin <franky.lin@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	brcm80211 development <brcm80211-dev-list@broadcom.com>,
	Network Development <netdev@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16 June 2016 at 17:10, Kalle Valo <kvalo@codeaurora.org> wrote:
> Rafał Miłecki <zajec5@gmail.com> writes:
>
>> Removing P2P interface is handled by sending a proper request to the
>> firmware. On success firmware triggers an event and driver's handler
>> removes a matching interface.
>>
>> However on event timeout we remove interface directly from the cfg80211
>> callback. Current code doesn't handle this case correctly as it always
>> assumes rtnl to be unlocked.
>>
>> Fix it by adding an extra rtnl_locked parameter to functions and calling
>> unregister_netdevice when needed.
>>
>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>
> Failed to apply, please rebase:
>
> Applying: brcmfmac: fix lockup when removing P2P interface after event timeout
> Using index info to reconstruct a base tree...
> Falling back to patching base and 3-way merge...
> Auto-merging drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
> Auto-merging drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
> CONFLICT (content): Merge conflict in drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
> Auto-merging drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> Auto-merging drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> Failed to merge in the changes.
> Patch failed at 0001 brcmfmac: fix lockup when removing P2P interface after event timeout

What tree did you try it on?

I just went into a dir where I have cloned:
git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git

My HEAD commit is:
034fdd4 Merge ath-current from ath.git

And I can apply this patch cleanly doing:
curl https://patchwork.kernel.org/patch/9138925/mbox/ | git am

-- 
Rafał
