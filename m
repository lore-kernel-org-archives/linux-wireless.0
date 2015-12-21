Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:61369 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206AbbLUWpq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 17:45:46 -0500
Date: Mon, 21 Dec 2015 23:45:35 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Shikha SINGH <shikha.singh@st.com>
Cc: "aloisio.almeida@openbossa.org" <aloisio.almeida@openbossa.org>,
	"lauro.venancio@openbossa.org" <lauro.venancio@openbossa.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-nfc@lists.01.org" <linux-nfc@lists.01.org>,
	Raunaque Mujeeb QUAISER <raunaque.quaiser@st.com>,
	Manoj KUMAR <manoj.kumar@st.com>,
	Sylvain FIDELIS <sylvain.fidelis@st.com>,
	Patrick SOHN <patrick.sohn@st.com>,
	MMS_MMY_Applications_SW <MMS_MMY_Applications_SW@list.st.com>
Subject: Re: [[linux-nfc] PATCH v5 2/3] driver: nfc: Add ST95HF NFC
 Transceiver support
Message-ID: <20151221224535.GA15902@zurbaran.home> (sfid-20151221_234600_522899_52781CA9)
References: <1448019621-14259-1-git-send-email-shikha.singh@st.com>
 <1448019621-14259-3-git-send-email-shikha.singh@st.com>
 <20151220175053.GA4772@zurbaran.home>
 <39576D76C6222946921EC3820C1BEC0C06FEFED225@EAPEX1MAIL1.st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <39576D76C6222946921EC3820C1BEC0C06FEFED225@EAPEX1MAIL1.st.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Shikha,

On Mon, Dec 21, 2015 at 07:57:23PM +0800, Shikha SINGH wrote:
> Hello Samuel,
> 	Please see my answer below.
> 	
> >This looks a lot better than the initial version.
> >I only have one question:
> >
> >On Fri, Nov 20, 2015 at 06:40:20AM -0500, Shikha Singh wrote:
> >> +/*
> >> + * st95hf_send_recv_cmd() is for sending commands to ST95HF
> >> + * that are described in the cmd_array[]. It can optionally
> >> + * receive the response if the cmd request is of type
> >> + * SYNC. For that to happen caller must pass true to recv_res.
> >> + * For ASYNC request, recv_res is ignored and the
> >> + * function will never try to receive the response on behalf
> >> + * of the caller.
> >> + */
> >> +static int st95hf_send_recv_cmd(struct st95hf_context *st95context,
> >> +				enum st95hf_cmd_list cmd,
> >> +				int no_modif,
> >> +				struct param_list *list_array,
> >> +				bool recv_res)
> >> +{
> >> +	unsigned char spi_cmd_buffer[MAX_CMD_LEN];
> >> +	int i, ret;
> >> +	struct device *dev = &st95context->spicontext.spidev->dev;
> >How do you know this driver is still valid at that point ?
> >It seems to be a potential corner case against the driver's remove function, but
> >it seems to be a race nevertheless.
> 
> st95hf_send_recv_cmd() is a static function that can be called only when a NFC digital request is submitted to our driver.
> So in summary, it can be called either from an implemented NFC digital ops (such as st95hf_switch_rf()) or from the driver's threaded ISR.
> Now if we see the remove function of the driver i.e. st95hf_remove(), it waits for all the outstanding NFC digital request to finish via nfc_digital_unregister_device(stcontext->ddev).
>
Yes, that was my main concern but I forgot
nfc_digital_unregister_device() waits for its command workqueue to be
emptied before returning. So we're safe.

All 3 patches applied to nfc-next, thanks.

Cheers,
Samuel.
