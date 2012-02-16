Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60490 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301Ab2BPNAj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Feb 2012 08:00:39 -0500
Date: Thu, 16 Feb 2012 14:00:21 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Florian Fainelli <florian@openwrt.org>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com, gwingerde@gmail.com,
	Ivo Van Doorn <ivdoorn@gmail.com>,
	Andreas Hartmann <andihartmann@freenet.de>
Subject: Re: Poor RT2880 performance
Message-ID: <20120216130020.GG25833@redhat.com> (sfid-20120216_140043_013320_A3989346)
References: <4F390ED3.8010400@openwrt.org>
 <CAGXE3d90az_g3KyzPp-4NQoM2zmXaNSVo=7piM=q8EK9WdBp7A@mail.gmail.com>
 <4F3961FB.7020409@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <4F3961FB.7020409@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 13, 2012 at 08:18:19PM +0100, Florian Fainelli wrote:
> Le 02/13/12 14:45, Helmut Schaa a écrit :
> >On Mon, Feb 13, 2012 at 2:23 PM, Florian Fainelli<florian@openwrt.org>  wrote:
> >>I am playing with a RT2880-F based AP, with a N connected station, in a
> >>residential environment.
> >Mind to provide the RF and RT chipset identifications? rt2x00 should print them
> >out during module load (at least when compiled with debugging options).
> 
> Sure, here are the HW infos of the AP:
> Ralink RT2880   id:1 rev:1 running at 266.66 MHz
> phy0 -> rt2x00_set_chip: Info - Chipset detected - rt: 2860, rf:
> 0001, rev: 0101.

Did you try to revert commit (if you use kernel, which include it) ?

commit f0425beda4d404a6e751439b562100b902ba9c98
Author: Felix Fietkau <nbd@openwrt.org>
Date:   Sun Aug 28 21:11:01 2011 +0200

    mac80211: retry sending failed BAR frames later instead of tearing

It was already identified that it couse performace issues on rt2860
based APs.

Stanislaw

