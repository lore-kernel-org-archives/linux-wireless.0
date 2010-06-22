Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:18749 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753299Ab0FVRM3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jun 2010 13:12:29 -0400
Subject: Re: ASPM status for iwlwifi and power-management (in general)
From: reinette chatre <reinette.chatre@intel.com>
To: "sedat.dilek@gmail.com" <sedat.dilek@gmail.com>
Cc: wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Berg, Johannes" <johannes.berg@intel.com>,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <AANLkTilpqUnWG2CnMNZR7a45rY9cbqks3W-gkjsMbYOQ@mail.gmail.com>
References: <AANLkTilpqUnWG2CnMNZR7a45rY9cbqks3W-gkjsMbYOQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Jun 2010 10:12:28 -0700
Message-ID: <1277226748.25793.2267.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-06-22 at 03:44 -0700, Sedat Dilek wrote:

> Before I will try 'pcie_aspm=force' cheat-code I wanted to ask about
> the status of iwlwifi and ASPM.
> Is there code available. yet? Which kernel has it - linux-next,
> wireless-testing GIT, iwlwifi GIT?

iwl3945 will disable L0s if L1 enabled, and enable L0s if L1 disabled.
Please see iwl_apm_init which is called by iwl3945_apm_init

Reinette


