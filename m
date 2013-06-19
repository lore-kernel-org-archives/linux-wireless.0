Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38508 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934265Ab3FSLRX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jun 2013 07:17:23 -0400
Date: Wed, 19 Jun 2013 14:16:27 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: antonio@open-mesh.com
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com
Subject: re: brcm80211: make mgmt_tx in brcmfmac accept a NULL channel
Message-ID: <20130619111620.GA969@elgon.mountain> (sfid-20130619_131726_421496_89076948)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Antonio Quartulli,

This is a semi-automatic email about new static checker warnings.

The patch c2ff8cad6423: "brcm80211: make mgmt_tx in brcmfmac accept a
NULL channel" from Jun 11, 2013, leads to the following Smatch
complaint:

drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c:4052 brcmf_cfg80211_mgmt_tx()
	 error: we previously assumed 'chan' could be null (see line 4041)

drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
  4040			 */
  4041			if (chan)
                            ^^^^
New check reflects that "chan" can now be NULL.

  4042				freq = chan->center_freq;
  4043			else
  4044				brcmf_fil_cmd_int_get(vif->ifp, BRCMF_C_GET_CHANNEL,
  4045						      &freq);
  4046			chan_nr = ieee80211_frequency_to_channel(freq);
  4047			af_params->channel = cpu_to_le32(chan_nr);
  4048	
  4049			memcpy(action_frame->data, &buf[DOT11_MGMT_HDR_LEN],
  4050			       le16_to_cpu(action_frame->len));
  4051	
  4052			brcmf_dbg(TRACE, "Action frame, cookie=%lld, len=%d, freq=%d\n",
  4053				  *cookie, le16_to_cpu(action_frame->len),
  4054				  chan->center_freq);
                                  ^^^^^^
This needs to be updated as well.

regards,
dan carpenter
