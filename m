Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lunatiki.de ([85.214.70.22]:41406 "EHLO
	h1112006.serverkompetenz.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752438AbYBPNAp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Feb 2008 08:00:45 -0500
From: Patrick Grimm <patrick@lunatiki.de>
To: Richard Scherping <richard@scherping.de>
Subject: Re: [HOTFIX] Re: mac80211/iwl4965: ad-hoc broken in 2.6.25-rc1
Date: Sat, 16 Feb 2008 01:19:07 +0100
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
	linux-wireless@vger.kernel.org
References: <47B1F422.4060501@scherping.de> <D936D925018D154694D8A362EEB0892003ABCF72@orsmsx416.amr.corp.intel.com> <47B60044.9000801@scherping.de>
In-Reply-To: <47B60044.9000801@scherping.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200802160119.07856.patrick@lunatiki.de> (sfid-20080216_130105_856008_71F1E7E9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Freitag, 15. Februar 2008 22:12:36 schrieb Richard Scherping:
> Chatre, Reinette schrieb:
> >>> One more question ... did ad-hoc work for you before this patch?
> >>
> >> No. In my tests only ipw3945 works in Ad-Hoc mode.
> >
> > ok - that explains things. The patch assumes that ad-hoc mode is
> > working, which is unfortunately not the case. We have to fix this.
> >
> > Reinette
>
> As I said, I have tested with iwl4965 only. Seems as if there are more
> problems with ad-hoc and iwl3945. Did ad-hoc work in the "old" iwl3945
> (before the API change with old version 1.1.17, compared to new version
> 1.2.23/26)?
I have made some short tests with my working kernel 2.6.23.
Version 1.1.17 - 1.1.22 Ad-Hoc mode is working.
Version 1.1.23 -            Ad-Hoc mode is not working.

Changes in 1.2.23

* fix problem when rf_kill switch change during suspend/resume
* fix possible priv->mutex deadlock during suspend
* 3954 renames iwl3945_rate_scale_priv to iwl3945_rs_sta
* 4965 unify rate scale variable names for station data
* move uCode helper functions to iwl-helpers.h
* Makefile: enable building using "make -C /path/to/iwlwifi"
* fix iwl_mac_add_interface handler
* Fix race conditional panic
* remove redundant declaration of 'iwl3945_priv' and 'iwl4965_priv' structs
* document scan command
* remove iwl4965_tx_cmd
* move iwl4965_get_dma_hi_address function to iwl-helpers.h
* fix rate control algo reference leak
* fix rf_kill state inconsistent during suspend and resume
* fix priv->ucode_data_backup save problem
* iwl4965: fix mutex_unlock missed problem in iwl_mac_config exit path
* iwl4965: Remove redundant code in iwl4965_tx_cmd
* fix compilation warnings
* use pci_save_state() before calling pci_disable_device()
* skip mac80211 conf during a hardware scan and replay it afterwards
* delay firmware loading from pci_probe to network interface open
* Makefile: enable HT and HT_AGG by default

Patrick
