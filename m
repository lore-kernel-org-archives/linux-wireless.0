Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:22825 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904Ab3FEKPc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 06:15:32 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Antonio Quartulli <antonio@open-mesh.com>
CC: Antonio Quartulli <ordex@autistici.org>,
	Nicolas Cavallari <Nicolas.Cavallari@lri.fr>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath6kl-devel@qca.qualcomm.com" <ath6kl-devel@qca.qualcomm.com>
Subject: Re: ath6kl_mgmt_tx with NULL chan
References: <1370241587-2609-1-git-send-email-ordex@autistici.org>
	<1370271547.8227.16.camel@jlt4.sipsolutions.net>
	<51ACB068.8070006@lri.fr> <20130603171430.GE1226@ritirata.org>
	<8738swkhho.fsf@kamboji.qca.qualcomm.com>
	<20130605100332.GB2349@open-mesh.com>
Date: Wed, 5 Jun 2013 13:15:26 +0300
In-Reply-To: <20130605100332.GB2349@open-mesh.com> (Antonio Quartulli's
	message of "Wed, 5 Jun 2013 12:03:32 +0200")
Message-ID: <87ppw0j22p.fsf@kamboji.qca.qualcomm.com> (sfid-20130605_121534_830396_5FB68498)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Antonio Quartulli <antonio@open-mesh.com> writes:

> On Wed, Jun 05, 2013 at 02:57:07AM -0700, Kalle Valo wrote:
>> Antonio Quartulli <ordex@autistici.org> writes:
>> 
>> > I'm looking at ath6kl_mgmt_tx() in ath6kl/cfg80211.c and I've seen that the
>> > currently "configured" frequency can be obtained by reading the
>> > ath6kl_vif->ch_hint field.
>> >
>> > But, is this correct?
>> 
>> I did a quick look. To me using ch_hint looks correct.
>> 
>> > I couldn't see any real relation between the ch_hint field and the
>> > real frequency (probably because a lot of logic is hidden to the
>> > driver). I could only understand that the ch_hint field stores the
>> > frequency passed as parameter during the connection, but I have found
>> > no guarantee that this is the really used one.
>> 
>> Can you be more specific, please?
>> 
>> To me it looks that ch_hint is used both with ath6kl_wmi_reconnect_cmd()
>> and ath6kl_wmi_connect_cmd() commands, which both are used to connect to
>> a network. I don't see any other variables used for specifying the
>> frequency to the firmware. But I could just be blind...
>
> I agree with your analysis. My doubt came from the fact that I don't know what
> the firmware does and I was wondering whether it could ignore the channel passed
> as argument on connect for some reason.

It might do that, I'm not involved with the firmware development.

> Actually the doubt was raised due to the variable name "ch_HINT".

Yeah, the name is really misleading. But that's still legacy from the
pre-cleanup driver, so I wouldn't worry about that too much.

> But you are the ath6k expert :-) Therefore I guess this can work.

It should but you never know :)

But when modifying that code, please add a check to make sure that
channel 0 is not used by accident.

-- 
Kalle Valo
