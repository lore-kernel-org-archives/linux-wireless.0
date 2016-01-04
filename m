Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:50717 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbcADPaM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jan 2016 10:30:12 -0500
From: Sven Dziadek <sven.dziadek@gmx.de>
To: Larry.Finger@lwfinger.net, Jes.Sorensen@redhat.com,
	gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH] staging: rtl8723au: fix byte order problems
Date: Mon,  4 Jan 2016 16:29:34 +0100
Message-Id: <1451921374-471-1-git-send-email-sven.dziadek@gmx.de> (sfid-20160104_163017_259908_4F8D35F6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove byte order conversions.
Conversion is already done in usb_ops_linux.c when accessing usb port.
The deleted lines convert to little-endian and then call FillH2CCmd to
convert back. Additionally, they are applied to wrong types and
process wrong parts of variables later on.

Signed-off-by: Sven Dziadek <sven.dziadek@gmx.de>
---

I was looking for some Sparse warnings that I could fix and found this:

drivers/staging/rtl8723au//hal/rtl8723a_cmd.c:96:38: warning: cast to
restricted __le16
drivers/staging/rtl8723au//hal/rtl8723a_cmd.c:100:27: warning: cast to
restricted __le32
drivers/staging/rtl8723au//hal/rtl8723a_cmd.c:118:25: warning: incorrect
type in assignment (different base types)
drivers/staging/rtl8723au//hal/rtl8723a_cmd.c:118:25:    expected
unsigned int [unsigned] [usertype] <noident>
drivers/staging/rtl8723au//hal/rtl8723a_cmd.c:118:25:    got restricted
__le32 [usertype] <noident>

The rtl8723au drivers seems to work on many machines already, but
probably mostly on little-endian machines.
The file staging/rtl8723au/hal/rtl8723a_cmd.c contains four conversions
from or to little-endian that look suspicious.
The best example is:

int rtl8723a_set_rssi_cmd(struct rtw_adapter *padapter, u8 *param)
{
	*((u32 *)param) = cpu_to_le32(*((u32 *)param));

	FillH2CCmd(padapter, RSSI_SETTING_EID, 3, param);

	return _SUCCESS;
}

On little-endian, the conversion does nothing, but on big-endian, it
swaps the order and then only 3 bytes are used in FillH2CCmd (3rd
argument). So it actually ignores the original argument param.

I think it is best to delete these conversions because the actual
conversions are done when transferring data to or from the usb port already.

Unfortunately, I do not have the hardware to test it.
What do you think about the patch?

 drivers/staging/rtl8723au/hal/rtl8723a_cmd.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c b/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
index 1662c03c..57f5941 100644
--- a/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
+++ b/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
@@ -93,11 +93,9 @@ int FillH2CCmd(struct rtw_adapter *padapter, u8 ElementID, u32 CmdLen,
 
 		if (h2c_cmd & BIT(7)) {
 			msgbox_ex_addr = REG_HMEBOX_EXT_0 + (h2c_box_num * EX_MESSAGE_BOX_SIZE);
-			h2c_cmd_ex = le16_to_cpu(h2c_cmd_ex);
 			rtl8723au_write16(padapter, msgbox_ex_addr, h2c_cmd_ex);
 		}
 		msgbox_addr = REG_HMEBOX_0 + (h2c_box_num * MESSAGE_BOX_SIZE);
-		h2c_cmd = le32_to_cpu(h2c_cmd);
 		rtl8723au_write32(padapter, msgbox_addr, h2c_cmd);
 
 		bcmd_down = true;
@@ -115,8 +113,6 @@ exit:
 
 int rtl8723a_set_rssi_cmd(struct rtw_adapter *padapter, u8 *param)
 {
-	*((u32 *)param) = cpu_to_le32(*((u32 *)param));
-
 	FillH2CCmd(padapter, RSSI_SETTING_EID, 3, param);
 
 	return _SUCCESS;
@@ -127,7 +123,7 @@ int rtl8723a_set_raid_cmd(struct rtw_adapter *padapter, u32 mask, u8 arg)
 	u8 buf[5];
 
 	memset(buf, 0, 5);
-	put_unaligned_le32(mask, buf);
+	memcpy(buf, &mask, 4);
 	buf[4]  = arg;
 
 	FillH2CCmd(padapter, MACID_CONFIG_EID, 5, buf);
-- 
2.1.4

