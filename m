Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4303 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755334Ab3GaJgO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 05:36:14 -0400
Message-ID: <51F8DA75.8040903@broadcom.com> (sfid-20130731_113626_853715_F70706A6)
Date: Wed, 31 Jul 2013 11:35:49 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Ben Greear" <greearb@candelatech.com>,
	"Paul Stewart" <pstew@chromium.org>,
	"Felix Fietkau" <nbd@openwrt.org>, "Jouni Malinen" <j@w1.fi>
Subject: Re: 802.11 infrastructure for regression testing - upstream /
 mac80211 / cfg80211
References: <CAB=NE6Vm18RcDYQn+QoEzSG202HezT0rqV_hwb_UOzyecstu5w@mail.gmail.com>
In-Reply-To: <CAB=NE6Vm18RcDYQn+QoEzSG202HezT0rqV_hwb_UOzyecstu5w@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/31/2013 02:53 AM, Luis R. Rodriguez wrote:
> Folks,
>
> Back in 2009 Intel had put out a wifi-test tree [0] but that seems
> deprecated now. The git tree at least is gone. Can someone confirm if
> that's dead? We later had Google present at the 2010 San Francisco
> wireless summit [1] their test infrastructure using autotest. Last I
> checked that stuff was not merged back upstream to autotest. Can
> someone confirm ? Lastly we have mac80211_hwsim [2] and also a slew of
> internal testing infrastructures that obviously are not open.
>
> If we are to embark on a new journey towards an open testing
> infrastructure what should be used? Ben, you have some stuff, and I
> know you also report some interesting bugs with insane amount of
> stations. Is any of it open?
>
> AFAICT mac80211_hwism should and likely already is used for a slew of
> core API changes / tests. Addressing testing using that shoud
> hopefully address tons of testings and find a lot of issues. We'd then
> just need vendors to replicate behaviour on top of their drivers. The
> core test stuff though still needs to be available.
>
> What do we have, anyone have any lofty plans?

We have a large testing infrastructure consisting of shielded boxes, 
attenuators, etc. It is all exercised using tcl scripts and none of it 
is open today. Who knows what tomorrow will bring. The brcm80211 
open-source drivers are tested limited but nightly using it.

I am considering coming up with a new test framework for the brcm80211 
drivers using python scripting, which is why I started py80211 
experiment (available on github), but your mentioning of autotest makes 
me want to revisit that.

Regards,
Arend

> [0] http://wireless.kernel.org/en/developers/Testing/wifi-test
> [1] http://wireless.kernel.org/en/developers/Summits/SanFranciscoBayArea-2010
> [2] http://wireless.kernel.org/en/users/Drivers/mac80211_hwsim
>
>    Luis
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


