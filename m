Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:18339 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755601AbXKWLi4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2007 06:38:56 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: AR5006X on Fijitsu-Siemens Lifebook E8410 - not work
Date: Fri, 23 Nov 2007 12:39:25 +0100
References: <200711222310.01165.virec@inmail.sk> <58948.84.58.144.191.1195794193.squirrel@webmail.madwifi.org> <200711231154.56712.hs4233@mail.mn-solutions.de>
In-Reply-To: <200711231154.56712.hs4233@mail.mn-solutions.de>
Cc: "Nick Kossifidis" <mickflemm@gmail.com>, "Majo" <virec@inmail.sk>,
	linux-wireless@vger.kernel.org,
	"Michael Renzmann" <mrenzmann@madwifi.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200711231239.25603.hs4233@mail.mn-solutions.de> (sfid-20071123_113908_002186_A1508701)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 23 November 2007 11:54:56 Holger Schurig wrote:
> > Don't be fooled by the PCI ID - we already know that these
> > are not reliable to identify the chipset used on a
> > Atheros-based card. See also http://madwifi.org/ticket/1192.

Hmm, I also notices that in ticket 1192, neither the output
of "lspci" nor "lshw" doesn't even output the subsystem ID. The
MODULE_ALIAS() syntax doesn't seem to have a way to specify
subsystem IDs.

I have two Atheros based cards here, one is a D-Link DWL-G650,
one a Proxim 8470-WD. Both have the PCI ID 168C:0013. The
D-Link has the subsystem ID 1186:3a12, the Proxim has 14b7:0a40.

The driver for the Proxim card contains an INF file, which has
this section:

[Vendor]
; DisplayName               Section             DeviceID
; -----------               -------             --------
%LEX.DeviceDesc.CB22ag_G%   = LEX_CB22ag_01,    PCI\VEN_168C&DEV_0013&SUBSYS_0A1014B7
%LEX.DeviceDesc.CB22ag_S%   = LEX_CB22ag_02,    PCI\VEN_168C&DEV_0013&SUBSYS_AA1014B7
%LEX.DeviceDesc.CB22ab_G%   = LEX_CB22ab_01,    PCI\VEN_168C&DEV_0012&SUBSYS_0A001B47
%LEX.DeviceDesc.CB22ab_S%   = LEX_CB22ab_02,    PCI\VEN_168C&DEV_0012&SUBSYS_AA001B47
%LEX.DeviceDesc.CB22ab_A%   = LEX_CB22ab_03,    PCI\VEN_168C&DEV_0012&SUBSYS_1A001B47
%LEX.DeviceDesc.CB22g_G%    = LEX_CB22g_01,     PCI\VEN_168C&DEV_0013&SUBSYS_0A4014B7
%LEX.DeviceDesc.CB22g_S%    = LEX_CB22g_02,     PCI\VEN_168C&DEV_0013&SUBSYS_AA4014B7
%LEX.DeviceDesc.MB22ag%     = LEX_MB22ag_01,    PCI\VEN_168C&DEV_0013&SUBSYS_0A6014B7
%LEX.DeviceDesc.ORiNOCO%    = LEX_ORiNOCO,      PCI\VEN_168C&DEV_0013&SUBSYS_04101467

And, as it turns out, the driver for the Proxim card doesn't
recognize the D-Link card, because it looks not only at the
PCI-ID, but also at the subsystem ID.

It would be interesting to get a list of the subsystem IDs of
misdetected atheros-based WLAN cards.
