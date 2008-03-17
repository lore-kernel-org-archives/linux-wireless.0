Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:24735 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309AbYCQP51 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2008 11:57:27 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: BUG: scheduling while atomic
Date: Mon, 17 Mar 2008 16:54:28 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	libertas-dev@lists.infradead.org
References: <200803171600.04805.hs4233@mail.mn-solutions.de> <1205766805.1614.114.camel@johannes.berg>
In-Reply-To: <1205766805.1614.114.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200803171654.28571.hs4233@mail.mn-solutions.de> (sfid-20080317_155830_394772_4FB1A388)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 17 March 2008 16:13:25 Johannes Berg wrote:
> That's pretty obvious:

I need to read more about those things LDD :-)

Thanks for explaining. I think I introduced this bug. I
just wonder why I didn't see it before, e.g. I didn't see
it this morning or when I was testing my patch "convert
CMD_MAC_CONTROL to a direct command"


This patch snippet from me produced the bug:


 int lbs_set_mac_packet_filter(struct lbs_private *priv)
 {
        int ret = 0;
+       struct cmd_ds_mac_control cmd;

        lbs_deb_enter(LBS_DEB_CMD);

-       /* Send MAC control command to station */
-       ret = lbs_prepare_and_send_command(priv,
-                                   CMD_MAC_CONTROL, 0, 0, 0, NULL);
+       cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+       cmd.action = cpu_to_le16(priv->currentpacketfilter);
+       cmd.reserved = 0;
+
+       ret = lbs_cmd_with_response(priv, CMD_MAC_CONTROL, &cmd);



The original code did not contain CMD_OPTION_WAITFORRSP, so my
translation to lbs_cmd_with_response() was wrong. I'll cook up
a patch soon.
