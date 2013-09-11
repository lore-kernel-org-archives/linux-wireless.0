Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754039Ab3IKU4H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Sep 2013 16:56:07 -0400
Message-ID: <1378933233.1693.31.camel@dcbw.foobar.com> (sfid-20130911_225611_196612_F847D2AB)
Subject: Re: Is there an utility analog athstat in madwifi for linux
 wireless???
From: Dan Williams <dcbw@redhat.com>
To: Beat Meier <mbe_shop@swiss-wireless.com.ar>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 11 Sep 2013 16:00:33 -0500
In-Reply-To: <52309B0A.7030504@swiss-wireless.com.ar>
References: <52309B0A.7030504@swiss-wireless.com.ar>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-09-11 at 13:32 -0300, Beat Meier wrote:
> Hello
> 
> Is there any tool for wireless debugging like athstat for madwifi which
> tells you CRC errors, long retries etc.??

You're probably looking for 'debugfs', which has the following counters:

	DEBUGFS_ADD_COUNTER(rx_packets, rx_packets);
	DEBUGFS_ADD_COUNTER(tx_packets, tx_packets);
	DEBUGFS_ADD_COUNTER(rx_bytes, rx_bytes);
	DEBUGFS_ADD_COUNTER(tx_bytes, tx_bytes);
	DEBUGFS_ADD_COUNTER(rx_duplicates, num_duplicates);
	DEBUGFS_ADD_COUNTER(rx_fragments, rx_fragments);
	DEBUGFS_ADD_COUNTER(rx_dropped, rx_dropped);
	DEBUGFS_ADD_COUNTER(tx_fragments, tx_fragments);
	DEBUGFS_ADD_COUNTER(tx_filtered, tx_filtered_count);
	DEBUGFS_ADD_COUNTER(tx_retry_failed, tx_retry_failed);
	DEBUGFS_ADD_COUNTER(tx_retry_count, tx_retry_count);
	DEBUGFS_ADD_COUNTER(wep_weak_iv_count, wep_weak_iv_count);

CRC errors might be represented by rx_dropped, but I'm not sure, as the
code doesn't split CRC errors out from other RX decryption errors.

Dan

