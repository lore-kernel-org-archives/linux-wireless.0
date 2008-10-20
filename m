Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:54306 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbYJTGrs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 02:47:48 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] libertas: fix CF firmware loading
Date: Mon, 20 Oct 2008 08:47:40 +0200
Cc: Dan Williams <dcbw@redhat.com>, linville@tuxdriver.com
References: <1224267349.4010.2.camel@dhcp-100-3-195.bos.redhat.com>
In-Reply-To: <1224267349.4010.2.camel@dhcp-100-3-195.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200810200847.40420.hs4233@mail.mn-solutions.de> (sfid-20081020_084751_039981_A6228AB8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> From: Ryan Mallon <ryan@bluewatersys.com>
>
> Change the return value of if_cs_poll_while_fw_download to
> zero on success, so that the firmware loading functions also
> correctly return zero on success.
>
> Signed-off-by: Ryan Mallon <ryan@bluewatersys.com>
> Acked-by: Dan Williams <dcbw@redhat.com>

The patch is ok, but the description is wrong.

The function is supposed to return some error back, which is 
negative, e.g. -ETIME. And callers test for (ret < 0) to find 
out about the error condition. See here:

ret = if_cs_poll_while_fw_download(card, IF_CS_C_SQ_READ_LOW, 
IF_CS_C_SQ_HELPER_OK)
if (ret < 0) {

ret = if_cs_poll_while_fw_download(card, IF_CS_C_STATUS,
                        IF_CS_C_S_CMD_DNLD_RDY);
if (ret < 0) {


ret = if_cs_poll_while_fw_download(card, IF_CS_SCRATCH, 0x5a);
if (ret < 0) {

... and so on.

That the function now returns "i", the number of iterations, is a 
remnant of old debug code, that showed me how many 
wait-iterations where needed.


So, from my point of view, the patch is completely unneeded, yet 
harmless.
