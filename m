Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38653 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbcAEJx3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2016 04:53:29 -0500
Date: Tue, 5 Jan 2016 12:53:20 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: shaharp@ti.com
Cc: linux-wireless@vger.kernel.org
Subject: re: wlcore/wl18xx: fw logger over sdio
Message-ID: <20160105095320.GC23619@mwanda> (sfid-20160105_105333_533168_69F37410)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Shahar Patury,

The patch 3719c17e1816: "wlcore/wl18xx: fw logger over sdio" from Dec
22, 2015, leads to the following static checker warning:

	drivers/net/wireless/ti/wlcore/event.c:63 wlcore_event_fw_logger()
	warn: unsigned 'ret' is never less than zero.

drivers/net/wireless/ti/wlcore/event.c
    39  int wlcore_event_fw_logger(struct wl1271 *wl)
    40  {
    41          u32 ret;
                ^^^^^^^^
Should be int.

    42          struct fw_logger_information fw_log;
    43          u8  *buffer;
    44          u32 internal_fw_addrbase = WL18XX_DATA_RAM_BASE_ADDRESS;
    45          u32 addr = WL18XX_LOGGER_SDIO_BUFF_ADDR;
    46          u32 end_buff_addr = WL18XX_LOGGER_SDIO_BUFF_ADDR +
    47                                  WL18XX_LOGGER_BUFF_OFFSET;
    48          u32 available_len;
    49          u32 actual_len;
    50          u32 clear_addr;
    51          size_t len;
    52          u32 start_loc;
    53  
    54          buffer = kzalloc(WL18XX_LOGGER_SDIO_BUFF_MAX, GFP_KERNEL);
    55          if (!buffer) {
    56                  wl1271_error("Fail to allocate fw logger memory");
    57                  fw_log.actual_buff_size = cpu_to_le32(0);
    58                  goto out;
    59          }
    60  
    61          ret = wlcore_read(wl, addr, buffer, WL18XX_LOGGER_SDIO_BUFF_MAX,
    62                            false);
    63          if (ret < 0) {
                    ^^^^^^^
Not possible.

    64                  wl1271_error("Fail to read logger buffer, error_id = %d",
    65                               ret);
    66                  fw_log.actual_buff_size = cpu_to_le32(0);
    67                  goto free_out;
    68          }
    69  
    70          memcpy(&fw_log, buffer, sizeof(fw_log));
    71  
    72          if (le32_to_cpu(fw_log.actual_buff_size) == 0)
    73                  goto free_out;
    74  
    75          actual_len = le32_to_cpu(fw_log.actual_buff_size);
    76          start_loc = (le32_to_cpu(fw_log.buff_read_ptr) -
    77                          internal_fw_addrbase) - addr;
    78          end_buff_addr += le32_to_cpu(fw_log.max_buff_size);
    79          available_len = end_buff_addr -
    80                          (le32_to_cpu(fw_log.buff_read_ptr) -
    81                                   internal_fw_addrbase);
    82          actual_len = min(actual_len, available_len);
    83          len = actual_len;
    84  
    85          wl12xx_copy_fwlog(wl, &buffer[start_loc], len);
    86          clear_addr = addr + start_loc + le32_to_cpu(fw_log.actual_buff_size) +
    87                          internal_fw_addrbase;
    88  
    89          len = le32_to_cpu(fw_log.actual_buff_size) - len;
    90          if (len) {
    91                  wl12xx_copy_fwlog(wl,
    92                                    &buffer[WL18XX_LOGGER_BUFF_OFFSET],
    93                                    len);
    94                  clear_addr = addr + WL18XX_LOGGER_BUFF_OFFSET + len +
    95                                  internal_fw_addrbase;
    96          }
    97  
    98          /* double check that clear address and write pointer are the same */
    99          if (clear_addr != le32_to_cpu(fw_log.buff_write_ptr)) {
   100                  wl1271_error("Calculate of clear addr Clear = %x, write = %x",
   101                               clear_addr, le32_to_cpu(fw_log.buff_write_ptr));
   102          }
   103  
   104          /* indicate FW about Clear buffer */
   105          ret = wlcore_write32(wl, addr + WL18XX_LOGGER_READ_POINT_OFFSET,
   106                               fw_log.buff_write_ptr);

wlcore_write32() is marked as __must_check but we don't actually check
the result.  Was there checking intended?

   107  free_out:
   108          kfree(buffer);
   109  out:
   110          return le32_to_cpu(fw_log.actual_buff_size);
   111  }
   112  EXPORT_SYMBOL_GPL(wlcore_event_fw_logger);

regards,
dan carpenter
