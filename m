Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:61025 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290AbZFHLWS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2009 07:22:18 -0400
Received: by bwz9 with SMTP id 9so2963430bwz.37
        for <linux-wireless@vger.kernel.org>; Mon, 08 Jun 2009 04:22:19 -0700 (PDT)
Message-ID: <4A2CF465.5090704@tuffmail.co.uk>
Date: Mon, 08 Jun 2009 12:22:13 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Marcel Holtmann <marcel@holtmann.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH v2] rfkill: remove set_global_sw_state
References: <1243885494.3015.29.camel@localhost.localdomain>	 <4A24559D.7010201@tuffmail.co.uk>	 <1243928308.3192.38.camel@localhost.localdomain>	 <1243929706.20064.7.camel@johannes.local>	 <1243930703.3192.59.camel@localhost.localdomain>	 <20090603040315.GA10464@khazad-dum.debian.net>	 <1244008652.4145.7.camel@localhost.localdomain>	 <20090603213340.GB22809@khazad-dum.debian.net>	 <1244088806.4145.24.camel@localhost.localdomain>	 <9b2b86520906070538s7def28f0nb269914e03207228@mail.gmail.com>	 <20090607125715.GC3340@khazad-dum.debian.net>	 <1244394963.12956.1.camel@johannes.local> <4A2BF833.1050906@tuffmail.co.uk>	 <4A2CE4A2.2090308@tuffmail.co.uk> <1244457159.18863.7.camel@johannes.local> <4A2CF3C1.20607@tuffmail.co.uk>
In-Reply-To: <4A2CF3C1.20607@tuffmail.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Alan Jenkins wrote:
> rfkill_set_global_sw_state() (previously rfkill_set_default()) will no
> longer be exported by the rewritten rfkill core.
>
> Instead, platform drivers which can provide persistent soft-rfkill state
> across power-down/reboot should indicate their initial state by calling
> rfkill_set_sw_state() before registration.  Otherwise, they will be
> initialized to a default value during registration by a set_block call.
>
> We remove existing calls to rfkill_set_sw_state() which happen before
> registration, since these had no effect in the old model.  If these
> drivers do have persistent state, the calls can be put back (subject
> to testing :-).  This affects hp-wmi and acer-wmi.
>
>
> Drivers with persistent state will affect the global state only if
> rfkill-input is enabled.  This is required, otherwise booting with
> wireless soft-blocked and pressing the wireless-toggle key once would
> have no apparent effect.  This special case will be removed in future
> along with rfkill-input, in favour of a more flexible userspace daemon
> (see Documentation/feature-removal-schedule.txt).
>
>
> Now rfkill_global_states[n].def is only used to preserve global states
> over EPO, it is renamed to ".sav".
>
> Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
> ---
> v2:
>  - fix thinkpad-acpi message to reflect altered error-case behaviour
>  - remove !CONFIG_RFKILL stub for rfkill_set_global_sw_state()
>   

Sorry, wrong patch, try again
