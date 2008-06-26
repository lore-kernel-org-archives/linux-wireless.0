Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:35711 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753962AbYFZCOc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2008 22:14:32 -0400
Subject: Re: [PATCH -next] iwlwifi: fix build for CONFIG_INPUT=n
From: Zhu Yi <yi.zhu@intel.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-wireless@vger.kernel.org, linux-next@vger.kernel.org,
	akpm <akpm@linux-foundation.org>, linville@tuxdriver.com
In-Reply-To: <20080624210246.0fe18e2c.randy.dunlap@oracle.com>
References: <20080624210246.0fe18e2c.randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Thu, 26 Jun 2008 10:13:30 +0800
Message-Id: <1214446410.14590.287.camel@debian.sh.intel.com> (sfid-20080626_041437_407078_35186D4E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-06-24 at 21:02 -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix iwlwifi so that it builds cleanly with CONFIG_INPUT=n.
> Also free the input device on exit.
> 
> drivers/built-in.o: In function `iwl_rfkill_unregister':
> (.text+0xbf430): undefined reference to `input_unregister_device'
> drivers/built-in.o: In function `iwl_rfkill_init':
> (.text+0xbf51c): undefined reference to `input_allocate_device'
> drivers/built-in.o: In function `iwl_rfkill_init':
> (.text+0xbf5bf): undefined reference to `input_register_device'
> drivers/built-in.o: In function `iwl_rfkill_init':
> (.text+0xbf5e9): undefined reference to `input_free_device'
> net/built-in.o: In function `rfkill_disconnect':
> rfkill-input.c:(.text+0xe71e1): undefined reference to
> `input_close_device'
> rfkill-input.c:(.text+0xe71e9): undefined reference to
> `input_unregister_handle'
> net/built-in.o: In function `rfkill_connect':
> rfkill-input.c:(.text+0xe723e): undefined reference to
> `input_register_handle'
> rfkill-input.c:(.text+0xe724d): undefined reference to
> `input_open_device'
> rfkill-input.c:(.text+0xe725c): undefined reference to
> `input_unregister_handle'
> net/built-in.o: In function `rfkill_handler_init':
> rfkill-input.c:(.init.text+0x36ec): undefined reference to
> `input_register_handler'
> net/built-in.o: In function `rfkill_handler_exit':
> rfkill-input.c:(.exit.text+0x112c): undefined reference to
> `input_unregister_handler'
> make[1]: *** [.tmp_vmlinux1] Error 1
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

ACK.

Thanks,
-yi

