Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:50037 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491AbbLUX03 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 18:26:29 -0500
Date: Tue, 22 Dec 2015 00:26:19 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Shikha SINGH <shikha.singh@st.com>
Cc: Manoj KUMAR <manoj.kumar@st.com>,
	"linux-nfc@lists.01.org" <linux-nfc@lists.01.org>,
	Sylvain FIDELIS <sylvain.fidelis@st.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Patrick SOHN <patrick.sohn@st.com>,
	MMS_MMY_Applications_SW <MMS_MMY_Applications_SW@list.st.com>
Subject: Re: [linux-nfc] [ PATCH v5 2/3] driver: nfc: Add ST95HF NFC
 Transceiver support
Message-ID: <20151221232619.GB15902@zurbaran.home> (sfid-20151222_002633_367683_E544EB9C)
References: <1448019621-14259-1-git-send-email-shikha.singh@st.com>
 <1448019621-14259-3-git-send-email-shikha.singh@st.com>
 <20151220175053.GA4772@zurbaran.home>
 <39576D76C6222946921EC3820C1BEC0C06FEFED225@EAPEX1MAIL1.st.com>
 <20151221224535.GA15902@zurbaran.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20151221224535.GA15902@zurbaran.home>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 21, 2015 at 11:45:35PM +0100, Samuel Ortiz wrote:
> Hi Shikha,
> 
> On Mon, Dec 21, 2015 at 07:57:23PM +0800, Shikha SINGH wrote:
> > Hello Samuel,
> > 	Please see my answer below.
> > 	
> > >This looks a lot better than the initial version.
> > >I only have one question:
> > >
> > >On Fri, Nov 20, 2015 at 06:40:20AM -0500, Shikha Singh wrote:
> > >> +/*
> > >> + * st95hf_send_recv_cmd() is for sending commands to ST95HF
> > >> + * that are described in the cmd_array[]. It can optionally
> > >> + * receive the response if the cmd request is of type
> > >> + * SYNC. For that to happen caller must pass true to recv_res.
> > >> + * For ASYNC request, recv_res is ignored and the
> > >> + * function will never try to receive the response on behalf
> > >> + * of the caller.
> > >> + */
> > >> +static int st95hf_send_recv_cmd(struct st95hf_context *st95context,
> > >> +				enum st95hf_cmd_list cmd,
> > >> +				int no_modif,
> > >> +				struct param_list *list_array,
> > >> +				bool recv_res)
> > >> +{
> > >> +	unsigned char spi_cmd_buffer[MAX_CMD_LEN];
> > >> +	int i, ret;
> > >> +	struct device *dev = &st95context->spicontext.spidev->dev;
> > >How do you know this driver is still valid at that point ?
> > >It seems to be a potential corner case against the driver's remove function, but
> > >it seems to be a race nevertheless.
> > 
> > st95hf_send_recv_cmd() is a static function that can be called only when a NFC digital request is submitted to our driver.
> > So in summary, it can be called either from an implemented NFC digital ops (such as st95hf_switch_rf()) or from the driver's threaded ISR.
> > Now if we see the remove function of the driver i.e. st95hf_remove(), it waits for all the outstanding NFC digital request to finish via nfc_digital_unregister_device(stcontext->ddev).
> >
> Yes, that was my main concern but I forgot
> nfc_digital_unregister_device() waits for its command workqueue to be
> emptied before returning. So we're safe.
> 
> All 3 patches applied to nfc-next, thanks.
Just a side note: I removed the 2 calls you had in your driver to BUG()
and replaced them with WARN() calls.
BUG() is really meant for unrecoverable system errors as it crashes the
machine. I don't think an NFC driver should call it.

Cheers,
Samuel.
