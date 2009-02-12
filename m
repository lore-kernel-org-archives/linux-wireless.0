Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:47125 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757623AbZBLUxB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Feb 2009 15:53:01 -0500
Subject: Re: Automatic/manual regulatory settings
From: Dan Williams <dcbw@redhat.com>
To: Jan Schneider <jan@horde.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20090212181959.11876f8viq636hs0@neo.wg.de>
References: <20090212181959.11876f8viq636hs0@neo.wg.de>
Content-Type: text/plain
Date: Thu, 12 Feb 2009 15:51:23 -0500
Message-Id: <1234471883.24344.2.camel@localhost> (sfid-20090212_215308_103435_E34E2A42)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-02-12 at 18:19 +0100, Jan Schneider wrote:
> While looking at logs collected for my microcode crash problem I  
> noticed that cfg80211 loads US regulatory settings.
> If I understand the documentation correctly the actual country should  
> be set either by the AP or the device using cfg80211. Neither seems to  
> happen, so is it the "correct" way to do this through the  
> ieee80211_regdom module parameter? And I wonder how this is supposed  
> to happen "idiot-proof" in the future?

In the future it would get set by whatever configures your network
connection.  Either system scripts like ifup/ifdown, or configured
manually in the config files that ifup/ifdown use, or automatically via
NetworkManager based on some setting, or via NetworkManager based on a
user-override.

One idea I've toyed with for NetworkManager is using the city you select
in the GUI Timezone control panel that all desktop environments for
timezone selection.  Just a thought.  Or, it could come from a
system-wide setting by your sysadmin in /etc, or set on a per-connection
basis when you set up the NetworkManager connection for that AP in the
NM connection editor.

Dan


