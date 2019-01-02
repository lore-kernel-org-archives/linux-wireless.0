Return-Path: <SRS0=/oVT=PK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74124C43387
	for <linux-wireless@archiver.kernel.org>; Wed,  2 Jan 2019 08:19:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4DFBB21871
	for <linux-wireless@archiver.kernel.org>; Wed,  2 Jan 2019 08:19:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728769AbfABITi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 2 Jan 2019 03:19:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40868 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726059AbfABITh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Jan 2019 03:19:37 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CA7EF5D68A;
        Wed,  2 Jan 2019 08:19:36 +0000 (UTC)
Received: from localhost (ovpn-204-181.brq.redhat.com [10.40.204.181])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 021885D757;
        Wed,  2 Jan 2019 08:19:35 +0000 (UTC)
Date:   Wed, 2 Jan 2019 09:19:34 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Tom Psyborg <pozega.tomislav@gmail.com>
Cc:     linux-wireless@vger.kernel.org,
        Randy Oostdyk <linux-kernel@oostdyk.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>
Subject: Re: [PATCH v2 3/3] rt2x00: do not print error when queue is full
Message-ID: <20190102081934.GA5300@redhat.com>
References: <1545318971-28351-1-git-send-email-sgruszka@redhat.com>
 <1545318971-28351-3-git-send-email-sgruszka@redhat.com>
 <CAKR_QVJeteexpQX=pJm17WrrarmihYw56hKuTbsNagbcA6U96A@mail.gmail.com>
 <20181221095938.GA29536@redhat.com>
 <CAKR_QVKQMcGGpY_3ur9kFjuYpaKgca=YfUJxjSjLEfP1HELuJw@mail.gmail.com>
 <20181227102535.GA25885@redhat.com>
 <CAKR_QVK_2j6a9YiwUEKuWF+ss0-pr808Sr=AUrX4a6L3Zw=F0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="YZ5djTAD1cGYuMQK"
Content-Disposition: inline
In-Reply-To: <CAKR_QVK_2j6a9YiwUEKuWF+ss0-pr808Sr=AUrX4a6L3Zw=F0w@mail.gmail.com>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Wed, 02 Jan 2019 08:19:37 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 28, 2018 at 01:45:27AM +0100, Tom Psyborg wrote:
> >
> > I move prints to debug level for for "arrived at non-free entry" from
> > "Dropping frame due to full tx queue" . For some users those 5 patches
> > improve things, they fix problem of router connection hung completely.
> > Printk problem is connection stall due to CPU being busy, but
> > is possible to reconnect to AP after that. It's different issue.
> >
> yes they fix hung. same hung that does this single patch fix by moving
> to dbg so they're not printed at all. FYI "Dropping frame due to full
> tx queue" causes "arrived at non-free entry" eventually that freezes
> interface so only reboot helps, removing "Dropping frame due to full
> tx queue" from printing to logs prevents this kind of hung and is
> better solution than 5 patches.

I wonder why are you confident about this ? And also why 5 patches
fixed the hung if there were still "Dropping frame ..." prints ?

Anyway I'll ask people on the bz for confirmation, if stop printing
is sufficient to fix the wifi hung.

> oh and don't forget to add note that
> rt2x00_err/rt2x00_dbg prints can cause serious bug so you don't
> acidentally enable them again in a year or two!

I think I will remember that, for others git changelog should
be sufficient.
 
> > Also 'result in lower throughput' is over-generalized statement. More
> > precise would be 'it lower throughput on some test cases', but even
> > in those specific cases, throughput vary randomly with and without
> > patches.
> >
> 
> 100Mbps TX 70Mbps RX without and 80Mbps TX 55 Mbps RX with 5
> patches--> EA2750 HT40 CH2 4.14.82+4.19-rc5-1-1

Ok, this is different case that you presented before on USB devices.
And I'm more concerned about it, because changes with MMIO ware
much bigger (for USB only some code was moved and some flush
changed were done). Please check attached patch, if it fixes
throughput regression for you ?

Thanks
Stanislaw

--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="rt2800_only_check_wcid_for_match.patch"

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index fe365cda0841..17e87e9b3d19 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -961,8 +961,7 @@ static bool rt2800_txdone_entry_check(struct queue_entry *entry, u32 reg)
 {
 	__le32 *txwi;
 	u32 word;
-	int wcid, ack, pid;
-	int tx_wcid, tx_ack, tx_pid, is_agg;
+	int wcid, tx_wcid;
 
 	/*
 	 * This frames has returned with an IO error,
@@ -972,23 +971,17 @@ static bool rt2800_txdone_entry_check(struct queue_entry *entry, u32 reg)
 	if (test_bit(ENTRY_DATA_IO_FAILED, &entry->flags))
 		return false;
 
-	wcid	= rt2x00_get_field32(reg, TX_STA_FIFO_WCID);
-	ack	= rt2x00_get_field32(reg, TX_STA_FIFO_TX_ACK_REQUIRED);
-	pid	= rt2x00_get_field32(reg, TX_STA_FIFO_PID_TYPE);
-	is_agg	= rt2x00_get_field32(reg, TX_STA_FIFO_TX_AGGRE);
-
 	/*
 	 * Validate if this TX status report is intended for
-	 * this entry by comparing the WCID/ACK/PID fields.
+	 * this entry by comparing the WCID field.
 	 */
 	txwi = rt2800_drv_get_txwi(entry);
-
 	word = rt2x00_desc_read(txwi, 1);
 	tx_wcid = rt2x00_get_field32(word, TXWI_W1_WIRELESS_CLI_ID);
-	tx_ack  = rt2x00_get_field32(word, TXWI_W1_ACK);
-	tx_pid  = rt2x00_get_field32(word, TXWI_W1_PACKETID);
 
-	if (wcid != tx_wcid || ack != tx_ack || (!is_agg && pid != tx_pid)) {
+	wcid = rt2x00_get_field32(reg, TX_STA_FIFO_WCID);
+
+	if (wcid != tx_wcid) {
 		rt2x00_dbg(entry->queue->rt2x00dev,
 			   "TX status report missed for queue %d entry %d\n",
 			   entry->queue->qid, entry->entry_idx);

--YZ5djTAD1cGYuMQK--
