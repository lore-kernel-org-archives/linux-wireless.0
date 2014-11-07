Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44127 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbaKGKGB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2014 05:06:01 -0500
Date: Fri, 7 Nov 2014 13:05:43 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Luciano Coelho <luciano.coelho@intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: wli1271: buffer overflow static checker warning
Message-ID: <20141107100543.GA16332@mwanda> (sfid-20141107_110613_152500_F21F3559)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Luciano Coelho,

The patch f5fc0f86b02a: "wl1271: add wl1271 driver files" from Aug 6,
2009, leads to the following static checker warning:

	drivers/net/wireless/ti/wlcore/cmd.c:894 wlcore_cmd_configure_failsafe()
	warn: is 'buf' large enough for 'struct acx_header'?

drivers/net/wireless/ti/wlcore/cmd.c
   886  int wlcore_cmd_configure_failsafe(struct wl1271 *wl, u16 id, void *buf,
   887                                    size_t len, unsigned long valid_rets)
   888  {
   889          struct acx_header *acx = buf;
   890          int ret;
   891  
   892          wl1271_debug(DEBUG_CMD, "cmd configure (%d)", id);
   893  
   894          acx->id = cpu_to_le16(id);

"len" is the size of the "buf" buffer.

The warning is because wl1271_tm_cmd_test() and friends check if
len is too large but they don't check if it's too small.

   895  
   896          /* payload length, does not include any headers */
   897          acx->len = cpu_to_le16(len - sizeof(*acx));
   898  
   899          ret = wlcore_cmd_send_failsafe(wl, CMD_CONFIGURE, acx, len, 0,
   900                                         valid_rets);
   901          if (ret < 0) {
   902                  wl1271_warning("CONFIGURE command NOK");
   903                  return ret;
   904          }
   905  
   906          return ret;
   907  }

See also:

	drivers/net/wireless/ti/wl1251/cmd.c:29 wl1251_cmd_send()
	warn: is 'buf' large enough for 'struct wl1251_cmd_header'?

regards,
dan carpenter
