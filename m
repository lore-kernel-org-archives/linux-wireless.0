Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:32040 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771AbZBLWnD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Feb 2009 17:43:03 -0500
Received: by yx-out-2324.google.com with SMTP id 8so508441yxm.1
        for <linux-wireless@vger.kernel.org>; Thu, 12 Feb 2009 14:43:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1234471883.24344.2.camel@localhost>
References: <20090212181959.11876f8viq636hs0@neo.wg.de>
	 <1234471883.24344.2.camel@localhost>
Date: Thu, 12 Feb 2009 14:43:01 -0800
Message-ID: <43e72e890902121443s307163ecide0f40bdc5a5818f@mail.gmail.com> (sfid-20090212_234310_613430_6CFC39C5)
Subject: Re: Automatic/manual regulatory settings
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Dan Williams <dcbw@redhat.com>
Cc: Jan Schneider <jan@horde.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 12, 2009 at 12:51 PM, Dan Williams <dcbw@redhat.com> wrote:
> On Thu, 2009-02-12 at 18:19 +0100, Jan Schneider wrote:
>> While looking at logs collected for my microcode crash problem I
>> noticed that cfg80211 loads US regulatory settings.
>> If I understand the documentation correctly the actual country should
>> be set either by the AP or the device using cfg80211. Neither seems to
>> happen, so is it the "correct" way to do this through the
>> ieee80211_regdom module parameter? And I wonder how this is supposed
>> to happen "idiot-proof" in the future?
>
> In the future it would get set by whatever configures your network
> connection.  Either system scripts like ifup/ifdown, or configured
> manually in the config files that ifup/ifdown use, or automatically via
> NetworkManager based on some setting, or via NetworkManager based on a
> user-override.
>
> One idea I've toyed with for NetworkManager is using the city you select
> in the GUI Timezone control panel that all desktop environments for
> timezone selection.  Just a thought.  Or, it could come from a
> system-wide setting by your sysadmin in /etc, or set on a per-connection
> basis when you set up the NetworkManager connection for that AP in the
> NM connection editor.

I think it'd be nice to leverage all these different possible location
based hints to help with your location -- and more. I think GeoClue
does such a thing (works with dbus and all), but I have not yet had
time to try it.

http://www.freedesktop.org/wiki/Software/GeoClue

  Luis
