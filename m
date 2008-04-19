Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.176]:37875 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232AbYDSA2P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Apr 2008 20:28:15 -0400
Received: by wa-out-1112.google.com with SMTP id m16so1285153waf.23
        for <linux-wireless@vger.kernel.org>; Fri, 18 Apr 2008 17:28:14 -0700 (PDT)
Message-ID: <1ba2fa240804181728u7a3440cajbba7dcc696d02909@mail.gmail.com> (sfid-20080419_012828_054068_85631A10)
Date: Sat, 19 Apr 2008 03:28:14 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: RE: iwl3945 problem with 2.6.25-rc9
Cc: "Brian Morrison" <bdm@fenrir.org.uk>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1208558382.4848.63.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <D936D925018D154694D8A362EEB08920043535A1@orsmsx416.amr.corp.intel.com>
	 <D936D925018D154694D8A362EEB0892004353826@orsmsx416.amr.corp.intel.com>
	 <D936D925018D154694D8A362EEB08920043539AE@orsmsx416.amr.corp.intel.com>
	 <fu931e$k1b$1@ger.gmane.org>
	 <D936D925018D154694D8A362EEB089200438B6D6@orsmsx416.amr.corp.intel.com>
	 <1208555842.4848.56.camel@johannes.berg>
	 <D936D925018D154694D8A362EEB089200438B728@orsmsx416.amr.corp.intel.com>
	 <20080418232358.000fbdf7@peterson.fenrir.org.uk>
	 <1208558255.4848.60.camel@johannes.berg>
	 <1208558382.4848.63.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Apr 19, 2008 at 1:39 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sat, 2008-04-19 at 00:37 +0200, Johannes Berg wrote:
>
>  > What I've found (a long time ago with hostapd) is that some APs are slow
>  > and the firmware-assisted scanning has a too small dwell period. Maybe
>  > we should have a module option for that so we can ask people to change
>  > that in such cases? You could try to change the IWL_ACTIVE_DWELL_TIME_24
>  > (and/or IWL_ACTIVE_DWELL_TIME_52) to higher values and maybe setting
>  > IWL_PLCP_QUIET_THRESH to 0.
>
>  Just as a datapoint, mac80211's sw scanning uses about 30 msec for
>  active and 200 for passive (on both bands).
>
First of all we have some scanning fixes coming soon
Second the 3954 and 4965 my uCode may crash intentionally if you send
probe requests on a passive channel.according EEPROM.
I personally  wish to not make SW scanning possible at all for that reason.
Third the scanning on passive channels is a bit conservative we need
to changed that in the FW.
At last iwlwifi HW scanning can handle up to 4 essids for direct scan
but currently wireless tools interface cannot utilize this.

Tomas


>  johannes
>
