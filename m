Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f177.google.com ([209.85.219.177]:43355 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759635AbZCQJbq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2009 05:31:46 -0400
Received: by ewy25 with SMTP id 25so3784043ewy.37
        for <linux-wireless@vger.kernel.org>; Tue, 17 Mar 2009 02:31:43 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Antonio Marques <froz@icix.org>
Subject: Re: rt2x00 mesh support
Date: Tue, 17 Mar 2009 10:31:41 +0100
Cc: Andrey Yurovsky <andrey@cozybit.com>,
	linux-wireless@vger.kernel.org
References: <E8FC0565-5438-4AB5-A004-CD31DD9C1AA3@icix.org> <200903161558.01070.IvDoorn@gmail.com> <A1AF7AF9-047F-41A1-829F-94F58821DB09@icix.org>
In-Reply-To: <A1AF7AF9-047F-41A1-829F-94F58821DB09@icix.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_932vJJ/whiwIZ1+"
Message-Id: <200903171031.41302.IvDoorn@gmail.com> (sfid-20090317_103150_606981_0D5CC206)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_932vJJ/whiwIZ1+
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 16 March 2009, Antonio Marques wrote:
> On Mar 16, 2009, at 14:58 , Ivo van Doorn wrote:
> > On Monday 16 March 2009, Ant=F3nio Marques wrote:
> >>
> >> As requested, I have attached the output of the script run before and
> >> after
> >> running 'iwlist mesh scan'. Unfortunately there seems to be no =20
> >> change in
> >> the output. I have also included the queue statistics as these do
> >> change from
> >> one state to the next. Any further pointers to help debug this? I'll
> >> gladly test
> >> any patches that try to address this issue.
> >
> > The dumps aren't correct, I had forgotten to update the script on =20
> > the website
> > after some API for the rt2x00 debugfs interface changes recently.
> > Attached is the correct patch.
> >
> > Ivo
> > <rt2x00_regdump.sh>
>=20
> Fixed, new dumps are attached.

Thanks for the dumps, the reason why the beaconing isn't working
is (fortunately) very obvious from the registers point of view.
The "generate beacons" bit is simply not enabled. However the reason
why this bit has not been set escapes me. Could you apply the attached
patch? This will add extra debug messages to the driver to see when the
beacon generation bit is set.

Thanks,

Ivo

--Boundary-00=_932vJJ/whiwIZ1+
Content-Type: text/x-diff;
  charset="iso-8859-15";
  name="rt73usb.beacon.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="rt73usb.beacon.diff"

diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 24fdfdf..0824e15 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -519,6 +519,7 @@ static void rt73usb_config_intf(struct rt2x00_dev *rt2x00dev,
 {
 	unsigned int beacon_base;
 	u32 reg;
+	u32 reg2;
 
 	if (flags & CONFIG_UPDATE_TYPE) {
 		/*
@@ -538,6 +539,8 @@ static void rt73usb_config_intf(struct rt2x00_dev *rt2x00dev,
 		rt2x00_set_field32(&reg, TXRX_CSR9_TSF_SYNC, conf->sync);
 		rt2x00_set_field32(&reg, TXRX_CSR9_TBTT_ENABLE, 1);
 		rt2x00usb_register_write(rt2x00dev, TXRX_CSR9, reg);
+		rt2x00usb_register_read(rt2x00dev, TXRX_CSR9, &reg2);
+		ERROR(rt2x00dev, "TXRX_CSR9 WRITE: 0x%.08x, READ: 0x%.08x\n", reg, reg2);
 	}
 
 	if (flags & CONFIG_UPDATE_MAC) {
@@ -838,6 +841,7 @@ static void rt73usb_config_duration(struct rt2x00_dev *rt2x00dev,
 				    struct rt2x00lib_conf *libconf)
 {
 	u32 reg;
+	u32 reg2;
 
 	rt2x00usb_register_read(rt2x00dev, TXRX_CSR0, &reg);
 	rt2x00_set_field32(&reg, TXRX_CSR0_TSF_OFFSET, IEEE80211_HEADER);
@@ -851,6 +855,8 @@ static void rt73usb_config_duration(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_INTERVAL,
 			   libconf->conf->beacon_int * 16);
 	rt2x00usb_register_write(rt2x00dev, TXRX_CSR9, reg);
+	rt2x00usb_register_read(rt2x00dev, TXRX_CSR9, &reg2);
+	ERROR(rt2x00dev, "TXRX_CSR9 WRITE: 0x%.08x, READ: 0x%.08x\n", reg, reg2);
 }
 
 static void rt73usb_config_ps(struct rt2x00_dev *rt2x00dev,
@@ -1139,6 +1145,7 @@ static int rt73usb_load_firmware(struct rt2x00_dev *rt2x00dev,
 static int rt73usb_init_registers(struct rt2x00_dev *rt2x00dev)
 {
 	u32 reg;
+	u32 reg2;
 
 	rt2x00usb_register_read(rt2x00dev, TXRX_CSR0, &reg);
 	rt2x00_set_field32(&reg, TXRX_CSR0_AUTO_TX_SEQ, 1);
@@ -1205,6 +1212,8 @@ static int rt73usb_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 0);
 	rt2x00_set_field32(&reg, TXRX_CSR9_TIMESTAMP_COMPENSATE, 0);
 	rt2x00usb_register_write(rt2x00dev, TXRX_CSR9, reg);
+	rt2x00usb_register_read(rt2x00dev, TXRX_CSR9, &reg2);
+	ERROR(rt2x00dev, "TXRX_CSR9 WRITE: 0x%.08x, READ: 0x%.08x\n", reg, reg2);
 
 	rt2x00usb_register_write(rt2x00dev, TXRX_CSR15, 0x0000000f);
 
@@ -1375,12 +1384,16 @@ static int rt73usb_enable_radio(struct rt2x00_dev *rt2x00dev)
 
 static void rt73usb_disable_radio(struct rt2x00_dev *rt2x00dev)
 {
+	u32 reg2;
+
 	rt2x00usb_register_write(rt2x00dev, MAC_CSR10, 0x00001818);
 
 	/*
 	 * Disable synchronisation.
 	 */
 	rt2x00usb_register_write(rt2x00dev, TXRX_CSR9, 0);
+	rt2x00usb_register_read(rt2x00dev, TXRX_CSR9, &reg2);
+	ERROR(rt2x00dev, "TXRX_CSR9 WRITE: 0x%.08x, READ: 0x%.08x\n", 0, reg2);
 
 	rt2x00usb_disable_radio(rt2x00dev);
 }
@@ -1532,6 +1545,7 @@ static void rt73usb_write_beacon(struct queue_entry *entry)
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
 	unsigned int beacon_base;
 	u32 reg;
+	u32 reg2;
 
 	/*
 	 * Add the descriptor in front of the skb.
@@ -1549,6 +1563,8 @@ static void rt73usb_write_beacon(struct queue_entry *entry)
 	rt2x00_set_field32(&reg, TXRX_CSR9_TBTT_ENABLE, 0);
 	rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 0);
 	rt2x00usb_register_write(rt2x00dev, TXRX_CSR9, reg);
+	rt2x00usb_register_read(rt2x00dev, TXRX_CSR9, &reg2);
+	ERROR(rt2x00dev, "TXRX_CSR9 WRITE: 0x%.08x, READ: 0x%.08x\n", reg, reg2);
 
 	/*
 	 * Write entire beacon with descriptor to register.
@@ -1584,6 +1600,7 @@ static void rt73usb_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
 				  const enum data_queue_qid queue)
 {
 	u32 reg;
+	u32 reg2;
 
 	if (queue != QID_BEACON) {
 		rt2x00usb_kick_tx_queue(rt2x00dev, queue);
@@ -1602,7 +1619,10 @@ static void rt73usb_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
 		rt2x00_set_field32(&reg, TXRX_CSR9_TBTT_ENABLE, 1);
 		rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 1);
 		rt2x00usb_register_write(rt2x00dev, TXRX_CSR9, reg);
-	}
+		rt2x00usb_register_read(rt2x00dev, TXRX_CSR9, &reg2);
+		ERROR(rt2x00dev, "TXRX_CSR9 WRITE: 0x%.08x, READ: 0x%.08x\n", reg, reg2);
+	} else
+		ERROR(rt2x00dev, "TXRX_CSR9 WRITE: Beacon generation already enabled\n");
 }
 
 /*

--Boundary-00=_932vJJ/whiwIZ1+--
