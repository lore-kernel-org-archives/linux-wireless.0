Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:41780 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753982AbZCJE72 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2009 00:59:28 -0400
Subject: Re: kernel BUG at drivers/net/wireless/iwlwifi/iwl3945-base.c:3127!
From: reinette chatre <reinette.chatre@intel.com>
To: Jason Andryuk <jandryuk@gmail.com>
Cc: Samuel Ortiz <samuel@sortiz.org>, Tomas Winkler <tomasw@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1236649234.6685.9.camel@rainbow>
References: <760481.57662.qm@web57614.mail.re1.yahoo.com>
	 <c4d76b3b0903011937p6538adbfpc0dab859a6742394@mail.gmail.com>
	 <1236141120.12734.2.camel@rainbow> <1236194370.6612.73.camel@rc-desk>
	 <c4d76b3b0903041147s2138e72bjb39864f87b4cd09e@mail.gmail.com>
	 <1236211493.6612.90.camel@rc-desk> <1236297052.6153.4.camel@rainbow>
	 <1236299085.6612.229.camel@rc-desk> <1236312734.19328.37.camel@rainbow>
	 <1236317982.12430.9.camel@rc-desk>  <1236649234.6685.9.camel@rainbow>
Content-Type: text/plain
Date: Mon, 09 Mar 2009 22:04:26 -0700
Message-Id: <1236661466.15923.53.camel@rc-desk> (sfid-20090310_055946_605059_DB46251E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jason,

On Mon, 2009-03-09 at 18:40 -0700, Jason Andryuk wrote:
> I thought I had made a big breakthrough when I found the solution to
> getting
> "iwlwifi: use iwl_cmd instead of iwl3945_cmd"
> bb64785ad94d575fe4f5f9e69f4f6c0b24e9905d to work.  Then I discovered
> that casting to iwl3945_tx_cmd was fixed later by "iwl3945: use
> iwl3945_tx_cmd instead of iwl_tx_cmd" fadd267e...


Does this mean if you apply commit fadd267e on top of
bb64785ad94d575fe4f5f9e69f4f6c0b24e9905d then things work? 

> 
> However, with this new knowledge, I was able to get farther.
> 
> Using my iwl3945_tx_cmd conversion patch, 

Is this the last patch you emailed? I don't think so as it (your last
patch) replaced iwl3945_cmd_meta and iwl3945_host_cmd.

> a patch for allocating rb_stts

could you please post this patch

> and a patch for the BUG_ON -> WARN_ON,

... and this one

>  I was able to narrow down commit
> "iwl3945: sync tx queue data structure with iwlagn"
> ff5010c3e12f1d0da27a5f871c2e3d5333dfbe2f as the one that starts
> introducing Microcode SW errors.
> 

I am not sure how your repository looks at this stage. What is your
latest wireless-testing commit and what patches do you have on top of
it?

> I tried adding in Reinette's iwl3945_hw_txq_free_tfd pci_unmap_single
> patch from earlier, but it did not fix the problem.
> 
> Would TX debugging output be more helpful?

You log below has a new error (similar to what you note in your next
email). "Unsupported interface type 515". This is very strange and
really looks like some corruption as this value is initialized with a
macro during probe. Could you enable mac and info debugging also (add
0x3 to your current debug flags)? This code has also changed a bit since
commit bb64785ad94d575fe4f5f9e69f4f6c0b24e9905d. 

You can also put a dump_stack() in iwl3945_connection_init_rx_config to
see where the call comes from and then trace the value of mode to see
where it is set to 515 ... it is supposed to be 2
(NL80211_IFTYPE_STATION).


> 
> Any thoughts on what could be going wrong?

I am finding it hard to keep track of things as what works and what does
not work appears to shift. I did install a 64bit system in the hopes of
reproducing your issue but could not with a basic open connect. How do
you connect to the AP? Please provide details that you think will enable
me to reproduce.

Thanks

Reinette



