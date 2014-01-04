Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:51318 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754373AbaADPur (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jan 2014 10:50:47 -0500
Date: Sat, 4 Jan 2014 16:52:27 +0100
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Peter Wu <lekensteyn@gmail.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [rt2x00usb] sleeping function called from invalid
 context at kernel/locking/mutex.c:616
Message-ID: <20140104155227.GA2134@localhost.localdomain> (sfid-20140104_165050_999384_72EF08FF)
References: <11195731.87o6OySWVz@al>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="BXVAT5kNtrzKuDFl"
In-Reply-To: <11195731.87o6OySWVz@al>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 26, 2013 at 01:00:50PM +0100, Peter Wu wrote:
> [30017.470835] BUG: sleeping function called from invalid context at kernel/locking/mutex.c:616
> [30017.470840] in_atomic(): 0, irqs_disabled(): 0, pid: 432, name: wpa_supplicant
> [30017.470843] 4 locks held by wpa_supplicant/432:
> [30017.470845]  #0:  (cb_lock){++++++}, at: [<ffffffff8151c3f9>] genl_rcv+0x19/0x40
> [30017.470856]  #1:  (genl_mutex){+.+.+.}, at: [<ffffffff8151df02>] genl_rcv_msg+0xc2/0xd0
> [30017.470861]  #2:  (rtnl_mutex){+.+.+.}, at: [<ffffffff814fdc97>] rtnl_lock+0x17/0x20
> [30017.470870]  #3:  (rcu_read_lock){.+.+..}, at: [<ffffffffa038efd5>] ieee80211_get_key+0x5/0x2f0 [mac80211]
> [30017.470895] CPU: 2 PID: 432 Comm: wpa_supplicant Tainted: G           O 3.13.0-rc4-custom-00256-gb7000ad #1
> [30017.470897] Hardware name: CLEVO CO.                        B7130                           /B7130                           , BIOS 6.00 08/27/2010
> [30017.470899]  0000000000000000 ffff880037b87870 ffffffff815da1f9 ffff88019630ea00
> [30017.470903]  ffff880037b87880 ffffffff81076a7d ffff880037b878f0 ffffffff815dde6c
> [30017.470907]  ffff880037b878b0 ffffffff815e2152 ffff880197cc25c0 0000000000000292
> [30017.470911] Call Trace:
> [30017.470917]  [<ffffffff815da1f9>] dump_stack+0x4e/0x7a
> [30017.470923]  [<ffffffff81076a7d>] __might_sleep+0xed/0x120
> [30017.470928]  [<ffffffff815dde6c>] mutex_lock_nested+0x3c/0x400
> [30017.470931]  [<ffffffff815e2152>] ? _raw_write_unlock_irqrestore+0x42/0x70
> [30017.470936]  [<ffffffff8117a40c>] ? create_object+0x23c/0x2f0
> [30017.470940]  [<ffffffffa05d832c>] rt2x00usb_vendor_request_buff+0x3c/0xd0 [rt2x00usb]
> [30017.470972]  [<ffffffffa05f61a3>] rt2x00usb_register_multiread+0x33/0x40 [rt2800usb]
> [30017.470983]  [<ffffffffa05e1638>] rt2800_get_tkip_seq+0x48/0x80 [rt2800lib]

get_tkip_seq() must be atomic, we can not assure that easily for USB
devices, hence the only possible fix seems to be disable TKIP
HW acceleration for USB devices.

Does the attached patch fix the problem for you?

BTW: I recommend you to switch to CCMP (AES) encryption anyway.

Stanislaw

--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="rt2x00_disable_tkip_on_usb.patch"

diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 2183e79..87d7938 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -489,6 +489,8 @@ int rt2x00mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	crypto.cipher = rt2x00crypto_key_to_cipher(key);
 	if (crypto.cipher == CIPHER_NONE)
 		return -EOPNOTSUPP;
+	if (crypto.cipher == CIPHER_TKIP && rt2x00_is_usb(rt2x00dev))
+		return -EOPNOTSUPP;
 
 	crypto.cmd = cmd;
 

--BXVAT5kNtrzKuDFl--
