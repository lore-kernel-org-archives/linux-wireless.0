Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:46379 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaAPVjx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jan 2014 16:39:53 -0500
Received: by mail-wg0-f51.google.com with SMTP id z12so3713347wgg.6
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jan 2014 13:39:51 -0800 (PST)
Date: Thu, 16 Jan 2014 22:43:57 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Bondar, Alexander" <alexander.bondar@intel.com>
Subject: Re: [PATCH 08/36] iwlwifi: mvm: Change power management dependency
 on multi MAC
Message-ID: <20140116214357.GA10376@gobelin> (sfid-20140116_224012_964091_8A7BDF64)
References: <52B0B72A.5070704@gmail.com>
 <1387313079-28123-8-git-send-email-egrumbach@gmail.com>
 <20140113111357.GA4611@magnum.frso.rivierawaves.com>
 <0BA3FCBA62E2DC44AF3030971E174FB303D3C4A5@HASMSX103.ger.corp.intel.com>
 <20140113124049.GA5796@magnum.frso.rivierawaves.com>
 <52D83C56.5010706@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <52D83C56.5010706@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 16, 2014 at 10:08:54PM +0200, Emmanuel Grumbach wrote:
> >>>
> >>> Hi,
> >>>
> >>> This broke monitor mode:
> >>> (unsetting .power_update_binding does not hang)
> >>>
> >>> modprobe iwlmvm
> >>> iw dev wlan0 set type monitor
> >>> iw dev wlan0 set freq 5180 40 5190  # hangs
> >>>
> >>> Can you reproduce it easily or do you need me to post further dbg info ?
> >>>
> >>
> >> We have an open bug on this internally - thanks for reporting.
> > 
> > OK, BTW I have errors like
> > - "Microcode SW error detected." upon monitor up
> 
> reading your mail again - is this related to monitor mode or not?
> 
Yes, at least that's part of what I meant by "upon monitor up", it seems
to happen systematically when I bring a monitor iface up.

> > - "iwlwifi 0000:02:00.0: FW error in SYNC CMD TXPATH_FLUSH" sometimes
> > after the subsequent ieee80211_restart_hw
> > - "WARNING: ... iwlwifi/mvm/binding.c:201 iwl_mvm_binding_remove_vif"
> >   when removing a monitor iface
> > 
> > You must have seen those too. I will avoid this tree with iwlwifi then.
> > 
> 
> I probably misunderstood this last sentence?

I ecountered many problems with mvm in this tree, Eyal quickly fixed the
rs unending search cycle, you told me the monitor deadlock was already
filed internally on your side, the ones I mentioned in this thread, also
it seems that with the 7260-8.ucode I don't get anything on a monitor
iface except the mere traffic of another associated iface (when I have
such one).
Except maybe for the latter?, these bugs seem easy enough to trigger
and alarming enough that I suspect you already must be on your way to
fixing what you deem needs to .. and thus I did not feel bad not
dissecting or reporting further and droping this tree with iwlwifi.
I hope this clarifies the meaning and intention of the last sentence.

I have been using the 7260 since last summer and, as I already mentioned
to Johannes, found it very useful, and wouldn't mind giving some
other out-of-tree patches a go.

 
Karl
