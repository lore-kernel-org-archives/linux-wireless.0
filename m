Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:58512 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbYDTUj1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Apr 2008 16:39:27 -0400
Received: by wa-out-1112.google.com with SMTP id m16so2572785waf.23
        for <linux-wireless@vger.kernel.org>; Sun, 20 Apr 2008 13:39:27 -0700 (PDT)
Message-ID: <1ba2fa240804201339u3232c5f6mede647c5c8521ae3@mail.gmail.com> (sfid-20080420_213934_100738_6B66EC2B)
Date: Sun, 20 Apr 2008 23:39:26 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: RE: iwl3945 problem with 2.6.25-rc9
Cc: "Brian Morrison" <bdm@fenrir.org.uk>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1208593973.26186.2.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <D936D925018D154694D8A362EEB08920043535A1@orsmsx416.amr.corp.intel.com>
	 <fu931e$k1b$1@ger.gmane.org>
	 <D936D925018D154694D8A362EEB089200438B6D6@orsmsx416.amr.corp.intel.com>
	 <1208555842.4848.56.camel@johannes.berg>
	 <D936D925018D154694D8A362EEB089200438B728@orsmsx416.amr.corp.intel.com>
	 <20080418232358.000fbdf7@peterson.fenrir.org.uk>
	 <1208558255.4848.60.camel@johannes.berg>
	 <1208558382.4848.63.camel@johannes.berg>
	 <1ba2fa240804181728u7a3440cajbba7dcc696d02909@mail.gmail.com>
	 <1208593973.26186.2.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Apr 19, 2008 at 11:32 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>  > Second the 3954 and 4965 my uCode may crash intentionally if you send
>  > probe requests on a passive channel.according EEPROM.
>
>  I really wonder what sort of error handling strategy that is, even if
>  it's done for regulatory compliance purposes I don't see a need to crash
>  the whole card. Especially considering that the userspace MLME in
>  wpa_supplicant will scan by itself (yes, it scans in userspace, whether
>  or not you may like that), of course it would be made comply with
>  regulatory settings but that makes it hard to develop.

It should not scan on not supported channel in any conditions. EEPROM
and reg.c has to be combined.

>
>  > I personally  wish to not make SW scanning possible at all for that reason.
>
>  That is not going to happen since you can always "scan" by sending probe
>  requests manually.

Probe request before association is  a must, no argue about it.

>  > At last iwlwifi HW scanning can handle up to 4 essids for direct scan
>  > but currently wireless tools interface cannot utilize this.
>
>  Does anybody actually *want* that? I personally dislike the behaviour of
>  scanning for all previously known SSIDs actively when hidden SSIDs are
>  so uncommon, I see it as an information disclosure vulnerability.

Sure you want that. User space applications handles number of
preferred SSIDs, let's call them profiles. It's desired that you do
direct scan for those SSIDss for faster connection.
Currently it takes 20 minutes  for NM to connect to network I want in
crowded air. (I'm exaggerating now I don't have real number...  but
it's something like that)
It's not just for hidden ssids.

Tomas
