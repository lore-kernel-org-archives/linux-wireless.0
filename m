Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:20463 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757486AbZIPKUv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2009 06:20:51 -0400
Received: from localhost (localhost [127.0.0.1])
	by localhost.mx51.mymxserver.com (Postfix) with ESMTP id 7D2A750009
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2009 12:20:53 +0200 (CEST)
Received: from mx51.mymxserver.com ([127.0.0.1])
	by localhost (mx51.mymxserver.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id B-mCwPc5rOKP for <linux-wireless@vger.kernel.org>;
	Wed, 16 Sep 2009 12:20:53 +0200 (CEST)
Received: from lin01.mn-solutions.de (pD95F9B84.dip0.t-ipconnect.de [217.95.155.132])
	by mx51.mymxserver.com (Postfix) with ESMTP id 207BA50008
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2009 12:20:52 +0200 (CEST)
Received: from mnz66.mn-solutions.de (mnz66.mn-solutions.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id DE70A1E0036
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2009 12:20:42 +0200 (CEST)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: question: ATH5K, antenna-mode and fall-throught in ath5k_hw_set_fast_div()
Date: Wed, 16 Sep 2009 12:20:11 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200909161220.11538.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi !

I have a device (fork-lift-terminal) where there is a PCCARD with
an Atheros chip inside it. The PCCARD has an built-in antenna and
a socket, where a cable goes to the external antenna.

Using madwifi, I always did:

        echo 2 >/proc/sys/dev/wifi0/rxantenna
        echo 2 >/proc/sys/dev/wifi0/txantenna
        echo 0 >/proc/sys/dev/wifi0/diversity

Now, with ath5k I'm planning to do this:

--- linux-wl.orig/drivers/net/wireless/ath/ath5k/base.c 2009-09-16 10:43:45.000000000 +0200
+++ linux-wl/drivers/net/wireless/ath/ath5k/base.c      2009-09-16 10:44:10.000000000 +0200
@@ -2850,5 +2850,5 @@ ath5k_config(struct ieee80211_hw *hw, u3
         * then we must allow the user to set how many tx antennas we
         * have available
         */
-       ath5k_hw_set_antenna_mode(ah, AR5K_ANTMODE_DEFAULT);
+       ath5k_hw_set_antenna_mode(ah, AR5K_ANTMODE_FIXED_B);


... as long as there is no offical interface for setting antenna
mode. A bit crude, but ... :-)



However, when looking for the antenna-related code-paths, I found
this:

ath5k_hw_set_fast_div(struct ath5k_hw *ah, u8 ee_mode, bool enable)
{
        switch (ee_mode) {
        case AR5K_EEPROM_MODE_11G:
                /* XXX: This is set to
                 * disabled on initvals !!! */
        case AR5K_EEPROM_MODE_11A:
        ...


In my case, ee_mode happens to be AR5K_EEPROM_MODE_11G, but I don't
understand the implication of this comment. Is the XXX something
to worry?  My card is a B/G only card, so I wonder if the
fall-through into the MODE_11A case is ok ?!?

-- 
http://www.holgerschurig.de
