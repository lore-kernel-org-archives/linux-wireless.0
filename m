Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57635 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab1LGJKh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Dec 2011 04:10:37 -0500
Subject: Re: [smatch stuff] question about iwlagn_rx_calib_result()
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1323248833.3404.7.camel@jlt3.sipsolutions.net> (sfid-20111207_100731_008636_CABCC4A6)
References: <20111207085923.GA15304@elgon.mountain>
	 (sfid-20111207_095943_156880_EC0FBF3D)  <1323248833.3404.7.camel@jlt3.sipsolutions.net>
	 (sfid-20111207_100731_008636_CABCC4A6)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Dec 2011 10:10:29 +0100
Message-ID: <1323249029.3404.9.camel@jlt3.sipsolutions.net> (sfid-20111207_101041_116715_14EF44C9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-12-07 at 10:07 +0100, Johannes Berg wrote:
> On Wed, 2011-12-07 at 11:59 +0300, Dan Carpenter wrote:
> > Smatch complains about iwlagn_rx_calib_result() it would be bad for
> > "len" to be negative.
> > 
> > drivers/net/wireless/iwlwifi/iwl-ucode.c
> > 
> >    299  int iwlagn_rx_calib_result(struct iwl_priv *priv,
> >    300                              struct iwl_rx_mem_buffer *rxb,
> >    301                              struct iwl_device_cmd *cmd)
> >    302  {
> >    303          struct iwl_rx_packet *pkt = rxb_addr(rxb);
> >    304          struct iwl_calib_hdr *hdr = (struct iwl_calib_hdr *)pkt->u.raw;
> >    305          int len = le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
> >    306  
> >    307          /* reduce the size of the length field itself */
> >    308          len -= 4;
> >                 ^^^^^^^^
> > Where does this 4 come from?  I've tried to determine what the minimum
> > size of "le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK" is but
> > I got lost.  Can it ever be less than 4?
> 
> 4 is sizeof(struct iwl_cmd_header) I think.
> 
> If the frame size ends up <= 4, that would be a major uCode/device bug
> since any frame has to start with len_n_flags & the header, of which the
> len_n_flags isn't included (see struct iwl_rx_packet).

Yeah, see iwl_rx_handle(). It adds sizeof(u32) for the rate_n_flags
field ("status word"). I suppose there could be some value in checking
that the length is at least 4, but I guess it should be in
iwl_rx_handle() and then smatch would still complain about
rx_calib_result().

johannes

