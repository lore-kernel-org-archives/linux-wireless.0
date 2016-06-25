Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:52135 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751349AbcFYSdN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jun 2016 14:33:13 -0400
Date: Sat, 25 Jun 2016 21:32:09 +0300
From: Jouni Malinen <j@w1.fi>
To: Erik Stromdahl <erik.stromdahl@gmail.com>
Cc: johannes@sipsolutions.net, johannes.berg@intel.com,
	kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH] mac80211_hwsim: Added vendor echo command
Message-ID: <20160625183209.GA3992@w1.fi> (sfid-20160625_203316_465923_9014CBC1)
References: <1466756034-5485-1-git-send-email-erik.stromdahl@gmail.com>
 <20160624204759.GA15514@w1.fi>
 <576EAC61.1050900@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <576EAC61.1050900@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 25, 2016 at 06:08:01PM +0200, Erik Stromdahl wrote:
> The mac80211_hwsim driver is currently defining the QCA vendor ID
> 0x001374 for some reason.

That is used for allowing nl80211 vendor specific commands and events to
be tested. The particular vendor command was properly assigned from the
QCA 00:13:74 OUI.

> Also, all current vendor commands are using the "QCA_" prefix, hence
> the reason why I decided to add the new vendor command with the
> "QCA_" prefix as well.
> 
> Anyway, I understand that you don't want the hwsim driver bloated
> with definitions that does not belong there.

That's not the issue here; the issue is in getting vendor subcommands
assigned by the entity who controls the OUI that is used. 

> Is there any reason why hwsim uses the QCA vendor id?

Yes, that's an OUI for which there is a process that allows new values
to be assigned.. I happen to be the one who is in control of assigning
such values.

> Perhaps it would be best if the hwsim driver would define its own vendor id?

That would need an OUI which are a bit expensive to acquire. I don't see
any point for mac80211_hwsim to need a different OUI since there is
already a friendly vendor who has provided an OUI that can be used for
this type of purposes.

In other words, you just need to follow the process defined for
assigning unique vendor subcommands/attribute identifiers for this OUI
00:13:74 and that process is what I pointed out in the previous email:

> >As far as the QCA vendor specific identifiers are concerned, their
> >assignment process is described here:
> >http://w1.fi/cgit/hostap/plain/src/common/qca-vendor.h

All you need to do is to prepare a hostap.git contribution that requests
a new subcommand/attribute to be assigned and once that gets applied to
the hostap.git master branch, the values have been assigned and can be
used for whatever purpose they were assigned, e.g., in mac80211_hwsim.

More details on how to make such a hostap.git contribution:
http://w1.fi/cgit/hostap/plain/CONTRIBUTIONS

-- 
Jouni Malinen                                            PGP id EFC895FA
