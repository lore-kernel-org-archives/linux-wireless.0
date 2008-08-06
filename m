Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:9636 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760401AbYHFT1A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Aug 2008 15:27:00 -0400
Received: by nf-out-0910.google.com with SMTP id d3so39288nfc.21
        for <linux-wireless@vger.kernel.org>; Wed, 06 Aug 2008 12:26:58 -0700 (PDT)
Message-ID: <4899FAFE.3020602@gmail.com> (sfid-20080806_212706_207444_6A6FAA9A)
Date: Wed, 06 Aug 2008 20:26:54 +0100
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	orinoco-devel@lists.sourceforge.net,
	Jean Tourrilhes <jt@hpl.hp.com>
Subject: Re: [PATCH 01/19] orinoco: Add ESSID specific scanning for Agere
 fw
References: <1217672073-7094-1-git-send-email-kilroyd@gmail.com>	 <1217672073-7094-2-git-send-email-kilroyd@gmail.com>	 <1217825304.10989.20.camel@dv>	 <1217864060.3139.10.camel@localhost.localdomain>	 <1217970944.2908.11.camel@dv>	 <1217973349.30531.1.camel@localhost.localdomain>	 <1217976491.2908.36.camel@dv>	 <1218028414.16977.5.camel@localhost.localdomain> <1218030485.27785.7.camel@ct>
In-Reply-To: <1218030485.27785.7.camel@ct>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
From: Dave <kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin wrote:
> I mean, if we request a scan with some parameters, and the cached
> results were received with different parameters, and real scanning is
> impossible now for whatever reason, then return empty results and EAGAIN
> code.
> 
> Anyway, we should have a policy for all drivers, so let's stick to that
> policy.

I've had a look at mac80211, since that seems to be a good indicator of policy (mlme.c). It caches BSSs in dev->ieee80211_ptr->local->sta_bss_list. It accumulates BSSs, and doesn't do anything to 'pick out' specific ssid results after a specific ssid scan is initiated, or clear the list before initiating the scan.

Without a mac80211 (or any other) card to check, it seems that the orinoco behaviour introduced by this patch is consistent with mac80211.


Regards,

Dave.
