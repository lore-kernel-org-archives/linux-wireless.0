Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:38147 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052AbYKDAPh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2008 19:15:37 -0500
Subject: Re: wireless-testing commit
	eb9d4e8399181357cb6f6625ba7f849987432c6c causes stalls
From: reinette chatre <reinette.chatre@intel.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Bob Copeland <me@bobcopeland.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"tim.gardner@canonical.com" <tim.gardner@canonical.com>,
	"mick@madwifi.org" <mick@madwifi.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <43e72e890811030040r6b090f7ai4b8aa9fc55b4f78c@mail.gmail.com>
References: <4908B754.1050400@tpi.com>
	 <1225696692.3619.18.camel@johannes.berg>
	 <43e72e890811022329g510a280wfd033538ee9b8c17@mail.gmail.com>
	 <1225697686.3619.25.camel@johannes.berg>
	 <43e72e890811022351m2c03e0b4g2a67a70cd6a7bd3c@mail.gmail.com>
	 <1225698867.3619.31.camel@johannes.berg>
	 <43e72e890811030001x7a3b166am440873fcf2c143d4@mail.gmail.com>
	 <1225699482.3619.34.camel@johannes.berg>
	 <43e72e890811030026t319c551cp91807318f9a6b838@mail.gmail.com>
	 <1225701024.3619.37.camel@johannes.berg>
	 <43e72e890811030040r6b090f7ai4b8aa9fc55b4f78c@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 03 Nov 2008 16:15:52 -0800
Message-Id: <1225757752.1115.495.camel@rc-desk> (sfid-20081104_011544_297465_FADDA825)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-11-03 at 00:40 -0800, Luis R. Rodriguez wrote:
> On Mon, Nov 3, 2008 at 12:30 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Mon, 2008-11-03 at 00:26 -0800, Luis R. Rodriguez wrote:
> >
> >> >> What should we do with these rare failures then?
> >> >
> >> > print an error message? ignore them? try again?
> >>
> >> I'd prefer a simple error print than a WARN_ON().
> >
> > Just so you don't get blamed on kerneloops.org? :)
> 
> No because like I said a hw reset can fail and don't think software
> should be blamed. Right now we do that.

fyi ...

We also have to deal with this in iwlwifi now because the driver chooses
not to send commands to the hardware if rfkill is enabled. If this is
the case (command needs to go to hw, but rfkill is enabled) then we
currently return an error ... triggering this warning. 

We cannot return success in this case and queuing the command for later
does not make sense. 

Reinette


