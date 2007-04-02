Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:44742 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965425AbXDBNvv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Apr 2007 09:51:51 -0400
Subject: Re: SIOCSIWAP behavior question
From: Dan Williams <dcbw@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Jouni Malinen <j@w1.fi>
In-Reply-To: <1175521655.9859.15.camel@localhost.localdomain>
References: <1175521655.9859.15.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 02 Apr 2007 09:55:28 -0400
Message-Id: <1175522128.9859.17.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2007-04-02 at 09:47 -0400, Dan Williams wrote:
> Should setting a BSSID trigger a disconnection event from the driver?

Hmm; badly phrased question.  I really meant:

Should setting a BSSID _always_ trigger a disconnection event from the
driver?

> Obviously a disconnect event shouldn't be triggered if the BSSID being
> set is the same BSSID the card is already associated with.  Or does that
> mean "reassociate unconditionally" ?
> 
> But suppose we have two APs in the same ESS with obviously different
> BSSIDs.  The card automatically associates with one BSSID, but
> wpa_supplicant decides it likes the other BSSID and calls SIOCSIWAP to
> lock to that one during the association process.  Should the driver
> issue an IWAP event of 00:00:00:00:00:00 before attempting
> re-association with the BSSID that wpa_supplicant wants?
> 
> The libertas driver currently does this; it sometimes confuses
> wpa_supplicant and is arguably wrong behavior because drivers don't
> issue disconnection events when auto-roaming from BSSID to BSSID in the
> same ESS.
> 
> Conversely, if you have two access points 'linksys' with different
> BSSIDs that really _are_ two different ESSs, this would screw up
> userspace tools if a disconnect _wasn't_ sent.  But in this case
> automatic tools have more problems than driver events.
> 
> Thoughts?  I guess I vote for not sending disconnect events if that
> BSSID has the same capabilities and the same SSID as the current
> association BSS.
> 
> Dan
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

