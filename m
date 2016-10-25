Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:51475 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1757544AbcJYQXE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Oct 2016 12:23:04 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Cathy Luo" <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        "briannorris@google.com" <briannorris@google.com>,
        Xinming Hu <huxm@marvell.com>
Subject: RE: [PATCH 3/5] mwifiex: do not free firmware dump memory in
 shutdown_drv
Date: Tue, 25 Oct 2016 16:23:01 +0000
Message-ID: <cacd29e6d17e46e598bcb4923c6d3297@SC-EXCH04.marvell.com> (sfid-20161025_182317_465624_A325FCC9)
References: <1477318892-22877-1-git-send-email-akarwar@marvell.com>
 <1477318892-22877-3-git-send-email-akarwar@marvell.com>
 <20161025001716.GF15034@dtor-ws>
In-Reply-To: <20161025001716.GF15034@dtor-ws>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dmitry,

> From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> Sent: Tuesday, October 25, 2016 5:47 AM
> To: Amitkumar Karwar
> Cc: linux-wireless@vger.kernel.org; Cathy Luo; Nishant Sarmukadam;
> briannorris@google.com; Xinming Hu
> Subject: Re: [PATCH 3/5] mwifiex: do not free firmware dump memory in
> shutdown_drv
> 
> On Mon, Oct 24, 2016 at 07:51:30PM +0530, Amitkumar Karwar wrote:
> > From: Xinming Hu <huxm@marvell.com>
> >
> > mwifiex_upload_device_dump() already takes care of freeing firmware
> > dump memory. Doing the same thing in mwifiex_shutdown_drv() is
> redundant.
> >
> > Signed-off-by: Xinming Hu <huxm@marvell.com>
> > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> > ---
> >  drivers/net/wireless/marvell/mwifiex/init.c | 19 -------------------
> >  1 file changed, 19 deletions(-)
> >
> > diff --git a/drivers/net/wireless/marvell/mwifiex/init.c
> > b/drivers/net/wireless/marvell/mwifiex/init.c
> > index 8e5e424..365efb8 100644
> > --- a/drivers/net/wireless/marvell/mwifiex/init.c
> > +++ b/drivers/net/wireless/marvell/mwifiex/init.c
> > @@ -407,8 +407,6 @@ static void mwifiex_free_lock_list(struct
> > mwifiex_adapter *adapter)  static void  mwifiex_adapter_cleanup(struct
> > mwifiex_adapter *adapter)  {
> > -	int idx;
> > -
> >  	if (!adapter) {
> >  		pr_err("%s: adapter is NULL\n", __func__);
> >  		return;
> > @@ -426,23 +424,6 @@ mwifiex_adapter_cleanup(struct mwifiex_adapter
> *adapter)
> >  	mwifiex_dbg(adapter, INFO, "info: free cmd buffer\n");
> >  	mwifiex_free_cmd_buffer(adapter);
> >
> > -	for (idx = 0; idx < adapter->num_mem_types; idx++) {
> > -		struct memory_type_mapping *entry =
> > -				&adapter->mem_type_mapping_tbl[idx];
> > -
> > -		if (entry->mem_ptr) {
> > -			vfree(entry->mem_ptr);
> > -			entry->mem_ptr = NULL;
> > -		}
> > -		entry->mem_size = 0;
> > -	}
> > -
> > -	if (adapter->drv_info_dump) {
> > -		vfree(adapter->drv_info_dump);
> > -		adapter->drv_info_dump = NULL;
> > -		adapter->drv_info_size = 0;
> > -	}
> 
> Why do you even keep the pointer to dump memory in the adapter
> structure? You allocate it in mwifiex_drv_info_dump() and immediately
> use it in mwifiex_upload_device_dump(). Why not simply pass the pointer
> between the functions?
> 

Thanks. This makes sense. I will pass the pointer and get rid of adapter variable in updated version.

Regards,
Amitkumar
