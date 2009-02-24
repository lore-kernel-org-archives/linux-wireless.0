Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:50965 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbZBXDMg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2009 22:12:36 -0500
Received: by qw-out-2122.google.com with SMTP id 5so1571738qwi.37
        for <linux-wireless@vger.kernel.org>; Mon, 23 Feb 2009 19:12:34 -0800 (PST)
Subject: Re: [PATCH] iwl3945: re-add iwl_poll_direct_bit return value check
From: Jason Andryuk <jandryuk@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	reinette chatre <reinette.chatre@intel.com>
In-Reply-To: <1235443534.7047.28.camel@rainbow>
References: <1235443534.7047.28.camel@rainbow>
Content-Type: text/plain
Date: Mon, 23 Feb 2009 22:12:31 -0500
Message-Id: <1235445152.6365.3.camel@rainbow> (sfid-20090224_041239_732949_509C55DE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-02-23 at 21:45 -0500, Jason Andryuk wrote:
> Re-add the iwl_poll_direct_bit return value assignment dropped in Commit
> 3fdd4102abceb4c99c5091674047b5c61fd3ebba "iwl3945: add apm ops".
> 
> Signed-off-by: Jason Andryuk <jandryuk@gmail.com>
> --

grep iwl_poll_direct_bit drivers/net/wireless/iwlwifi/*3945*.c
drivers/net/wireless/iwlwifi/iwl-3945.c:	ret = iwl_poll_direct_bit(priv, CSR_GP_CNTRL,
drivers/net/wireless/iwlwifi/iwl-3945.c:		iwl_poll_direct_bit(priv, FH39_TSSR_TX_STATUS,
drivers/net/wireless/iwlwifi/iwl-3945.c:	iwl_poll_direct_bit(priv, CSR_RESET,
drivers/net/wireless/iwlwifi/iwl-3945.c:	iwl_poll_direct_bit(priv, CSR_GP_CNTRL,
drivers/net/wireless/iwlwifi/iwl-3945.c:	rc = iwl_poll_direct_bit(priv, FH39_RSSR_STATUS,

Including this patch, only two out of five return values are checked.
It isn't clear to me how errors should be handled in all cases, so a
maintainer should probably take a look at these.

Jason

