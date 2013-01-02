Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2170 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752090Ab3ABMGE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 07:06:04 -0500
Message-ID: <50E4229D.5000900@broadcom.com> (sfid-20130102_130609_065028_4F035A48)
Date: Wed, 2 Jan 2013 13:05:49 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Linus Torvalds" <torvalds@linux-foundation.org>
cc: "Brett Rudley" <brudley@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Linux Wireless List" <linux-wireless@vger.kernel.org>,
	brcm80211-dev-list@broadcom.com,
	"Seth Forshee" <seth.forshee@canonical.com>
Subject: Re: WARNING: at
 drivers/net/wireless/brcm80211/brcmsmac/main.c:7539
References: <CA+55aFwpdyrtvE=86e1aHE9L5TR+_xP7e4PBBKtdcey3=f+Suw@mail.gmail.com>
In-Reply-To: <CA+55aFwpdyrtvE=86e1aHE9L5TR+_xP7e4PBBKtdcey3=f+Suw@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/28/2012 07:07 AM, Linus Torvalds wrote:
> Ok, maybe somebody is interested in this.. I don't know what triggered
> it, but maybe the few lines around it give some clue.

Hi Linus,

I am interested (being paid for it kinda helps). The warning itself does
not necessarily have to be a problem, but the frameid mismatch between
tx status info and the related buffer taken from the DMA ring does.
Smells like a race condition, but I need to investigate that.

> I think it's new to 3.8-rc1, because I haven't seen it before (well,
> I'm running current -git - v3.8.0-rc1-00035-g101e5c7470eb to be exact
> - but the networking changes since -rc1 are small and seem unrelated).
> But maybe it just happens under certain circumstances.

We had a big contribution from Canonical (cc-ed Seth) in brcmsmac
itself. Not playing the blame game, but I suspect it has altered
circumstances making the real issue (that was already there) more likely
to happen. Hope that helps us nailing it down.

>                     Linus
> 

Regards,
Arend

> ---
> [  573.596631] brcmsmac bcma0:0: brcms_ops_bss_info_changed: arp
> filtering: enabled true, count 1 (implement)
> [  584.154535] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete:
> Pkt tx suppressed, illegal channel possibly 1
> [  584.154628] brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete:
> Pkt tx suppressed, illegal channel possibly 1
> [  584.925487] ------------[ cut here ]------------
> [  584.925521] WARNING: at
> drivers/net/wireless/brcm80211/brcmsmac/main.c:7539
> brcms_c_wait_for_tx_completion+0xa3/0xc0 [brcmsmac]()


