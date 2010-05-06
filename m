Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:24937 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932074Ab0EFQLM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 May 2010 12:11:12 -0400
Subject: Re: [PATCH] iwlwifi: recalculate average tpt if not current
From: reinette chatre <reinette.chatre@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	Adel Gadllah <adel.gadllah@gmail.com>
In-Reply-To: <1272909307.7879.5759.camel@rchatre-DESK>
References: <1272907549-25847-1-git-send-email-linville@tuxdriver.com>
	 <1272908934.7879.5748.camel@rchatre-DESK>
	 <1272909307.7879.5759.camel@rchatre-DESK>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 May 2010 09:11:08 -0700
Message-ID: <1273162268.2226.2503.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

On Mon, 2010-05-03 at 10:55 -0700, reinette chatre wrote:
> From: Reinette Chatre <reinette.chatre@intel.com>
> 
> We currently have this check as a BUG_ON, which is being hit by people.
> Previously it was an error with a recalculation if not current, return that
> code.
> 
> The BUG_ON was introduced by:
> commit 3110bef78cb4282c58245bc8fd6d95d9ccb19749
> Author: Guy Cohen <guy.cohen@intel.com>
> Date:   Tue Sep 9 10:54:54 2008 +0800
> 
>     iwlwifi: Added support for 3 antennas
> 
> ... the portion adding the BUG_ON is reverted since we are encountering the error
> and BUG_ON was created with assumption that error is not encountered.
> 
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---

I noticed this patch in your wireless-next-2.6 pull request. Since it is
addressing a system hang issue, could it perhaps be included in
wireless-2.6 also? I should have included the bug report reference for
this purpose, sorry ... it is
https://bugzilla.redhat.com/show_bug.cgi?id=588021

Reinette

