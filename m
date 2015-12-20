Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:1229 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933430AbbLTRvD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Dec 2015 12:51:03 -0500
Date: Sun, 20 Dec 2015 18:50:53 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Shikha Singh <shikha.singh@st.com>
Cc: aloisio.almeida@openbossa.org, lauro.venancio@openbossa.org,
	linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
	raunaque.quaiser@st.com, manoj.kumar@st.com,
	sylvain.fidelis@st.com, patrick.sohn@st.com,
	MMS_MMY_Applications_SW@list.st.com
Subject: Re: [[linux-nfc] PATCH v5 2/3] driver: nfc: Add ST95HF NFC
 Transceiver support
Message-ID: <20151220175053.GA4772@zurbaran.home> (sfid-20151220_185110_634609_9FE299A2)
References: <1448019621-14259-1-git-send-email-shikha.singh@st.com>
 <1448019621-14259-3-git-send-email-shikha.singh@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1448019621-14259-3-git-send-email-shikha.singh@st.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Singh,

This looks a lot better than the initial version.
I only have one question:

On Fri, Nov 20, 2015 at 06:40:20AM -0500, Shikha Singh wrote:
> +/*
> + * st95hf_send_recv_cmd() is for sending commands to ST95HF
> + * that are described in the cmd_array[]. It can optionally
> + * receive the response if the cmd request is of type
> + * SYNC. For that to happen caller must pass true to recv_res.
> + * For ASYNC request, recv_res is ignored and the
> + * function will never try to receive the response on behalf
> + * of the caller.
> + */
> +static int st95hf_send_recv_cmd(struct st95hf_context *st95context,
> +				enum st95hf_cmd_list cmd,
> +				int no_modif,
> +				struct param_list *list_array,
> +				bool recv_res)
> +{
> +	unsigned char spi_cmd_buffer[MAX_CMD_LEN];
> +	int i, ret;
> +	struct device *dev = &st95context->spicontext.spidev->dev;
How do you know this driver is still valid at that point ?
It seems to be a potential corner case against the driver's remove
function, but it seems to be a race nevertheless.

Cheers,
Samuel.
