Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:10765 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755642AbYBZPXU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2008 10:23:20 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org
Subject: Re: [PATCH] libertas: implement SSID scanning for SIOCSIWSCAN
Date: Tue, 26 Feb 2008 15:20:32 +0100
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <200801281728.56885.hs4233@mail.mn-solutions.de> <1201631880.28652.13.camel@localhost.localdomain>
In-Reply-To: <1201631880.28652.13.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200802261520.32440.hs4233@mail.mn-solutions.de> (sfid-20080226_152325_123273_3CAB9D2F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 1) I don't think scan_ssid_len gets cleared in enough places.

lbs_scan_networks() is now static. This makes it easy to verify
that all code paths that call lbs_scan_networks() directly or=20
throught queue_delayed_work(..., &priv->scan_work, ...)=20
initialize scan_ssid_len.


> 2) might as well kill the filtered scan stuff in
> lbs_scan_networks().

Done.


> 3) Add
>
> =A0=A0=A0=A0=A0=A0=A0=A0range->scan_capa =3D IW_SCAN_CAPA_ESSID;

Done.


I'm sending the new version ASAP :-)
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
