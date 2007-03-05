Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:36364 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933403AbXCENSh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2007 08:18:37 -0500
Message-ID: <45EC18A9.50003@warmcat.com>
Date: Mon, 05 Mar 2007 13:18:33 +0000
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: Re: Filtering in Monitor Mode (was Question about PRISM2 header rate   field)
References: <45EA9E39.6080706@warmcat.com>	 <1173053744.6131.40.camel@johannes.berg> <45EB6C3B.2060408@warmcat.com>	 <200703042210.52534.flamingice@sourmilk.net>	 <1173094447.6131.56.camel@johannes.berg>  <45EC1454.4080605@warmcat.com> <1173099910.6131.71.camel@johannes.berg>
In-Reply-To: <1173099910.6131.71.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Mon, 2007-03-05 at 13:00 +0000, Andy Green wrote:
> 
>> I used the libpcap filter stuff to limit what I saw to just the packets 
>> of interest.  This is the filtering that tcpdump uses to do the 
>> conditional filters like "port 22" or "host 192.168.0.1".  The filter 
>> uses something called BPF (Berkeley Packet Filter) which is done 
>> kernelside (at least libpcap is doing the filter install with ioctls in 
>> pcap-bpf.c).  So the cost of drinking from a Monitor firehose is much 
>> less than it sounds.
> 
> Actually, I think the cost can be significant, especially for embedded
> systems. You traverse into userspace for each packet at least once, and
> a management entity in userspace will not be concerned with data packets
> at all. Also, a monitor interface currently always disables power save
> mode for many drivers.

Not sure I explained well enough: looking at libpcap sources, it 
compiles the filter you request into a bytecode and then gives it to the 
kernelside using an ioctl.  When you recv() or select() on the monitor 
interface after that, you block until something matching your filter 
definition turns up.  Userspace doesn't hear about the rest of it.

Filter definitions include stuff like testing specific offsets of the 
header or payload and boolean operators.

pcap-bpf.c:

static int
pcap_setfilter_bpf(pcap_t *p, struct bpf_program *fp)
{
...
        /*
          * Try to install the kernel filter.
          */
         if (ioctl(p->fd, BIOCSETF, (caddr_t)fp) < 0) {
                 snprintf(p->errbuf, PCAP_ERRBUF_SIZE, "BIOCSETF: %s",
                     pcap_strerror(errno));
                 return (-1);
         }
         p->md.use_bpf = 1;      /* filtering in the kernel */
...
}

 From the README.linux on libpcap:

''In addition, there is an option that, in 2.2 and later kernels, will
allow packet capture filters specified to programs such as tcpdump to be
executed in the kernel, so that packets that don't pass the filter won't
be copied from the kernel to the program, rather than having all packets
copied to the program and libpcap doing the filtering in user mode.

Copying packets from the kernel to the program consumes a significant
amount of CPU, so filtering in the kernel can reduce the overhead of
capturing packets if a filter has been specified that discards a
significant number of packets.  (If no filter is specified, it makes no
difference whether the filtering isn't performed in the kernel or isn't
performed in user mode. :-))

The option for this is the CONFIG_FILTER option''

-Andy
