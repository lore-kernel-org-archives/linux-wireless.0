Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3711 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752371Ab1CCJTo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2011 04:19:44 -0500
Date: Thu, 3 Mar 2011 10:19:19 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3 5/5] iwlwifi: move remaining iwl-agn-rx.c code into
 iwl-rx.c
Message-ID: <20110303091918.GA2190@redhat.com>
References: <1298899997-2372-1-git-send-email-sgruszka@redhat.com>
 <1298899997-2372-5-git-send-email-sgruszka@redhat.com>
 <1299096009.5082.127.camel@wwguy-huron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1299096009.5082.127.camel@wwguy-huron>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello

On Wed, Mar 02, 2011 at 12:00:09PM -0800, Guy, Wey-Yi wrote:
> I got the following warning:
> 
> drivers/net/wireless/iwlwifi/iwl-rx.c:506:6: warning: symbol
> 'iwl_rx_statistics' was not declared. Should it be static?
> drivers/net/wireless/iwlwifi/iwl-rx.c:575:6: warning: symbol
> 'iwl_reply_statistics' was not declared. Should it be static?
> drivers/net/wireless/iwlwifi/iwl-rx.c:600:6: warning: symbol
> 'iwl_rx_missed_beacon_notif' was not declared. Should it be static?

include "iwl-agh.h" should make warning go away, but perhaps
would be better to move all rx_handlers to iwl-rx.c, make them
statics and export only iwl_setup_rx_handlers ?

Stanislaw
