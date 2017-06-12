Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22978 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752383AbdFLT7T (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Jun 2017 15:59:19 -0400
Date: Mon, 12 Jun 2017 22:59:08 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: prameela.j04cs@gmail.com
Cc: linux-wireless@vger.kernel.org
Subject: [bug report] rsi: Add new host interface operations
Message-ID: <20170612195908.GA2079@elgon.mountain> (sfid-20170612_215922_375199_155C017E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Prameela Rani Garnepudi,

The patch b97e9b94ad75: "rsi: Add new host interface operations" from
May 16, 2017, leads to the following static checker warning:

	drivers/net/wireless/rsi/rsi_91x_usb.c:400 rsi_usb_master_reg_read()
	warn: passing casted pointer 'value' to 'rsi_usb_reg_read()' 32 vs 16.

drivers/net/wireless/rsi/rsi_91x_usb.c
   156  static int rsi_usb_reg_read(struct usb_device *usbdev,
   157                              u32 reg,
   158                              u16 *value,
   159                              u16 len)
   160  {
   161          u8 *buf;
   162          int status = -ENOMEM;
   163  
   164          buf  = kmalloc(0x04, GFP_KERNEL);

Why are we allocating 0x4 bytes?

   165          if (!buf)
   166                  return status;
   167  
   168          status = usb_control_msg(usbdev,
   169                                   usb_rcvctrlpipe(usbdev, 0),
   170                                   USB_VENDOR_REGISTER_READ,
   171                                   RSI_USB_REQ_IN,
   172                                   ((reg & 0xffff0000) >> 16), (reg & 0xffff),
   173                                   (void *)buf,
   174                                   len,
                                         ^^^
If len is more than 4 then we have memory corruption.

   175                                   USB_CTRL_GET_TIMEOUT);
   176  
   177          *value = (buf[0] | (buf[1] << 8));
   178          if (status < 0) {
   179                  rsi_dbg(ERR_ZONE,
   180                          "%s: Reg read failed with error code :%d\n",
   181                          __func__, status);
   182          }

[ snip ]

   394  static int rsi_usb_master_reg_read(struct rsi_hw *adapter, u32 reg,
   395                                     u32 *value, u16 len)
   396  {
   397          struct usb_device *usbdev =
   398                  ((struct rsi_91x_usbdev *)adapter->rsi_dev)->usbdev;
   399  
   400          return rsi_usb_reg_read(usbdev, reg, (u16 *)value, len);

This is an endian bug because we're assuming the CPU is little endian.

	u16 tmp;
	int ret;

	if (len != sizeof(*value)) /* Or maybe sizeof(tmp), who knows? */
		return -EINVAL;
	ret = rsi_usb_reg_read(usbdev, reg, &tmp, len);
	if (ret)
		return ret;

	*value = tmp;
	return 0;


   401  }

regards,
dan carpenter
