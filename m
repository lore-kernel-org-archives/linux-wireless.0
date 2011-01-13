Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59646 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932312Ab1AMB47 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jan 2011 20:56:59 -0500
Received: by iwn9 with SMTP id 9so1128901iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 12 Jan 2011 17:56:59 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-ID: <19758.23490.289502.491562@gargle.gargle.HOWL>
Date: Thu, 13 Jan 2011 07:26:18 +0530
To: =?iso-8859-1?Q?Bj=F6rn?= Smedman <bjorn.smedman@venatech.se>
Cc: Rajkumar Manoharan <rmanoharan@atheros.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC] ath9k: Handle interface changes properly
In-Reply-To: <AANLkTimK2AkRYnZk70TNt5YWEzNPCoPHpT=pu1B6JZPN@mail.gmail.com>
References: <1294842652-7406-1-git-send-email-rmanoharan@atheros.com>
	<AANLkTi=S6TFk88cY27KFZ2q5mCykMMSn17LnH=V95MST@mail.gmail.com>
	<19757.58191.865301.805439@gargle.gargle.HOWL>
	<AANLkTimK2AkRYnZk70TNt5YWEzNPCoPHpT=pu1B6JZPN@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Björn Smedman wrote:
> Thank you Sujith for the clarification. When you lay out the cases it
> makes more sense. But there are still border cases, like e.g. adding
> first a STA and then an AP interface. If I read main.c correctly the
> opmode will then be STA and the AP vif will be broken, right?
> 
> Wouldn't it be better to keep counts of number of vifs by type and
> e.g. activate SWBA if (adhocvifs > 0 || apvifs > 0) and similar? Then
> it wouldn't mater in which order vifs are added, removed and changed.

Yep, individual interface counters have to be maintained, since bringing
down one beaconing interface shouldn't disable SWBA altogether.
Also, we should allow only one IBSS interface, and deny multi-interfaces when
it is present.

Sujith
