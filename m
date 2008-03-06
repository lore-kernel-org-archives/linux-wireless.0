Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:38464 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255AbYCFSre (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Mar 2008 13:47:34 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Reinette Chatre <reinette.chatre@intel.com>
Subject: Re: [PATCH 2/2] iwlwifi: Moving EEPROM handling in iwlcore module
Date: Thu, 6 Mar 2008 19:46:36 +0100
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Assaf Krauss <assaf.krauss@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
References: <1204828820-11768-1-git-send-email-reinette.chatre@intel.com> <1204828820-11768-2-git-send-email-reinette.chatre@intel.com> <1204828820-11768-3-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1204828820-11768-3-git-send-email-reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200803061946.36591.mb@bu3sch.de> (sfid-20080306_184745_296920_403E2622)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 06 March 2008 19:40:20 Reinette Chatre wrote:
> +/*
> + * 4965 EEPROM map
> + */
> +struct iwl4965_eeprom {
> +	u8 reserved0[16];
> +#define EEPROM_DEVICE_ID                    (2*0x08)	/* 2 bytes */

offsetof() does this stuff automagically for you.

> +	u16 device_id;		/* abs.ofs: 16 */
> +	u8 reserved1[2];
> +#define EEPROM_PMC                          (2*0x0A)	/* 2 bytes */

...

> +	u16 pmc;		/* abs.ofs: 20 */
> +	u8 reserved2[20];
> +#define EEPROM_MAC_ADDRESS                  (2*0x15)	/* 6  bytes */

.. and so on.

> +	u8 mac_address[6];	/* abs.ofs: 42 */
> +	u8 reserved3[58];
> +#define EEPROM_BOARD_REVISION               (2*0x35)	/* 2  bytes */
> +	u16 board_revision;	/* abs.ofs: 106 */
> +	u8 reserved4[11];
> +#define EEPROM_BOARD_PBA_NUMBER             (2*0x3B+1)	/* 9  bytes */
> +	u8 board_pba_number[9];	/* abs.ofs: 119 */
> +	u8 reserved5[8];

-- 
Greetings Michael.
