Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost03.isp.att.net ([204.127.217.103]:46110 "EHLO
	fmailhost03.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933257AbZDBSTn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2009 14:19:43 -0400
Message-ID: <49D5018E.6050001@lwfinger.net> (sfid-20090402_202015_954960_4B77C38E)
Date: Thu, 02 Apr 2009 13:18:54 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: How does rfkill work?
References: <49D44635.80306@lwfinger.net>	 <1238666206.4141.12.camel@johannes.local>  <49D4CF50.2060100@lwfinger.net>	 <1238684527.4141.63.camel@johannes.local>  <49D4D833.9070107@lwfinger.net> <1238689637.24708.41.camel@johannes.local>
In-Reply-To: <1238689637.24708.41.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On my system that's exactly what it looks like with my patch (well,
> rfkill4 right now). I'm stumped. What kernel are you running?

The problem is the statement #define TRIG_NAME_MAX 50 in include/linux/leds.h.
When I make it 60, then the trigger file contains "none ide-disk ADP1-online
BAT0-charging-or-full BAT0-charging BAT0-full phy0rx phy0tx phy0assoc phy0radio
[rfkill0]" as expected.

I still have not found where radio gets truncated to rad, but I'm looking.

I'm running the master-2009-03-27 pull from wireless-testing with some added
patches.

Larry
