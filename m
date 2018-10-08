Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27689C65C20
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 14:20:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C14302075C
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 14:20:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C14302075C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbeJHVc1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 17:32:27 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:56456 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726383AbeJHVc1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 17:32:27 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1g9WOa-0007zk-NB; Mon, 08 Oct 2018 16:20:28 +0200
Message-ID: <1539008417.3687.57.camel@sipsolutions.net>
Subject: Re: [PATCH 03/19] wilc: add host_interface.h
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Ajay Singh <ajay.kathat@microchip.com>,
        linux-wireless@vger.kernel.org
Cc:     kvalo@codeaurora.org, gregkh@linuxfoundation.org,
        ganesh.krishna@microchip.com, aditya.shankar@microchip.com,
        venkateswara.kaja@microchip.com, claudiu.beznea@microchip.com,
        adham.abozaeid@microchip.com
Date:   Mon, 08 Oct 2018 16:20:17 +0200
In-Reply-To: <1537957525-11467-4-git-send-email-ajay.kathat@microchip.com> (sfid-20180926_122543_439724_F85DD368)
References: <1537957525-11467-1-git-send-email-ajay.kathat@microchip.com>
         <1537957525-11467-4-git-send-email-ajay.kathat@microchip.com>
         (sfid-20180926_122543_439724_F85DD368)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 (3.26.6-1.fc27) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2018-09-26 at 15:55 +0530, Ajay Singh wrote:

> +#include <linux/ieee80211.h>

you include it

> +#include "coreconfigurator.h"
> +
> +#define IDLE_MODE	0x00
> +#define AP_MODE		0x01
> +#define STATION_MODE	0x02
> +#define GO_MODE		0x03
> +#define CLIENT_MODE	0x04
> +#define ACTION		0xD0
> +#define PROBE_REQ	0x40
> +#define PROBE_RESP	0x50

please use it too.

> +#define ACTION_FRM_IDX				0
> +#define PROBE_REQ_IDX				1
> +#define MAX_NUM_STA				9
> +#define ACTIVE_SCAN_TIME			10
> +#define PASSIVE_SCAN_TIME			1200
> +#define MIN_SCAN_TIME				10
> +#define MAX_SCAN_TIME				1200
> +#define DEFAULT_SCAN				0
> +#define USER_SCAN				BIT(0)
> +#define OBSS_PERIODIC_SCAN			BIT(1)
> +#define OBSS_ONETIME_SCAN			BIT(2)
> +#define GTK_RX_KEY_BUFF_LEN			24
> +#define ADDKEY					0x1
> +#define REMOVEKEY				0x2
> +#define DEFAULTKEY				0x4
> +#define ADDKEY_AP				0x8
> +#define MAX_NUM_SCANNED_NETWORKS		100
> +#define MAX_NUM_SCANNED_NETWORKS_SHADOW		130
> +#define MAX_NUM_PROBED_SSID			10
> +#define CHANNEL_SCAN_TIME			250
> +
> +#define TX_MIC_KEY_LEN				8
> +#define RX_MIC_KEY_LEN				8
> +#define PTK_KEY_LEN				16
> +
> +#define TX_MIC_KEY_MSG_LEN			26
> +#define RX_MIC_KEY_MSG_LEN			48
> +#define PTK_KEY_MSG_LEN				39
> +
> +#define PMKSA_KEY_LEN				22
> +#define ETH_ALEN				6

umm?

> +#define PMKID_LEN				16

??

> +#define WILC_MAX_NUM_PMKIDS			16
> +#define WILC_ADD_STA_LENGTH			40
> +#define NUM_CONCURRENT_IFC			2
> +#define DRV_HANDLER_SIZE			5
> +#define DRV_HANDLER_MASK			0x000000FF

Also this file is strangely mixing
 * 802.11 constants (that you shouldn't have anyway)
 * driver constants/structs
 * hardware/firmware-related things (at least it seems like - e.g. the
   "REMOVEKEY" constant)

Please clean that up, separate the things, and pick a better
namespace... just having "REMOVEKEY" is probably not a good idea.

> +typedef void (*wilc_remain_on_chan_expired)(void *, u32);
> +typedef void (*wilc_remain_on_chan_ready)(void *);

Please no typedefs.

> +struct rcvd_net_info {
> +	u8 *buffer;
> +	u32 len;
> +};
> +
> +struct hidden_net_info {
> +	u8  *ssid;
> +	u8 ssid_len;
> +};
> +
> +struct hidden_network {
> +	struct hidden_net_info *net_info;
> +	u8 n_ssids;
> +};

This seems really odd - what part doesn't cfg80211 already handle?

johannes
