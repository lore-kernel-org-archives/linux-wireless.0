Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:35080 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767AbaHYUiR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Aug 2014 16:38:17 -0400
Received: by mail-lb0-f179.google.com with SMTP id v6so273982lbi.38
        for <linux-wireless@vger.kernel.org>; Mon, 25 Aug 2014 13:38:16 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Luca Coelho <luca@coelho.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	"Berg, Johannes" <johannes.berg@intel.com>
Subject: Re: Iwlwifi 3160 AC (firmware?) clashes with CONFIG_IWLWIFI_BCAST_FILTERING
Date: Mon, 25 Aug 2014 22:38:12 +0200
Message-ID: <2051772.0goyH0a5WI@debian64> (sfid-20140825_223821_107429_1E999AC4)
In-Reply-To: <CANUX_P28E+ubMrzAK45mqs672JFEo7ci=GuBWSm7i3G=WrUfeQ@mail.gmail.com>
References: <6715079.xd2j4mnUMo@debian64> <1408997366.17421.5.camel@dubbel> <CANUX_P28E+ubMrzAK45mqs672JFEo7ci=GuBWSm7i3G=WrUfeQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, August 25, 2014 11:20:29 PM Emmanuel Grumbach wrote:
> > Hi Christian,
> >
> > I'm not the best person to talk about the iwlwifi firmwares (that would
> > be Emmanuel, but he is not available now), but I'll try.
> 
> Here I am - thanks Luca for stepping in.
Hello you both!
 
> >
> >> [...]
> >> [ 1021.094192] Call Trace:
> >> [ 1021.094205]  [<ffffffff813ce9bd>] ? dump_stack+0x41/0x51
> >> [ 1021.094217]  [<ffffffffa0b9cd8b>] ? iwl_trans_pcie_send_hcmd+0x367/0x438 [iwlwifi]
> >> [ 1021.094226]  [<ffffffffa0b9b52c>] ? iwl_pcie_enqueue_hcmd+0x5e3/0x5fe [iwlwifi]
> >> [ 1021.094235]  [<ffffffff8105fd4c>] ? finish_wait+0x5d/0x5d
> >> [ 1021.094250]  [<ffffffffa0d50106>] ? iwl_mvm_send_cmd+0xd/0x22 [iwlmvm]
> >> [ 1021.094262]  [<ffffffffa0d50160>] ? iwl_mvm_send_cmd_pdu+0x45/0x52 [iwlmvm]
> >> [ 1021.094273]  [<ffffffffa0d4c5fb>] ? iwl_mvm_configure_bcast_filter.isra.14.part.15+0x36/0x3f [iwlmvm]
> >>
> >> (Full log attached below)
> >>
> >> What cough my eye was the "BAD_COMMAND" in the error log. I disabled
> >> "CONFIG_IWLWIFI_BCAST_FILTERING" option and the 3160 is now working.
> >>
> >> As far as I can tell, there is already a firmware feature flag:
> >> "IWL_UCODE_TLV_FLAGS_BCAST_FILTERING" which can be used to
> >> distinguish whenever the feature is supported or not. But it
> >> seems to be "stuck on" for the 3160.
> >
> > Weird, but it's possible that they set the flag mistakenly for the 3160
> > firmware.  I'll check this with the firmware team.
> >
> [...]
> Actually, we do have an internal ticket with this issue - but I don't
> know if it was on 3160 or on 7260. Your report explicitly says that
> you saw this on 3160, so I am only now connecting between the dots.
> I can't check the internal bug since I am on vacation right now. Note
> that 3160 is much less common than 7260 - so this kind of stupid bugs
> can stay unseen for a fairly long time...

I have some 7260s too. As far as I can tell, they both 
(one is a 7260-N, the other a 7260-AC) support the 
BCAST_FILTERING feature.

[I'll open a bug report @ iwlwifi#Bugzilla - and
check out 25.222.9.0 too [0]]

Regards
Christian

[0] <https://git.kernel.org/cgit/linux/kernel/git/egrumbach/linux-firmware.git/commit/?id=13dfdae12b8a8018abed2224db6ad1856817ab05>

