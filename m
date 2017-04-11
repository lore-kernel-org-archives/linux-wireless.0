Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:33492 "EHLO
        mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752086AbdDKTMG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Apr 2017 15:12:06 -0400
Received: by mail-pf0-f177.google.com with SMTP id s16so2796014pfs.0
        for <linux-wireless@vger.kernel.org>; Tue, 11 Apr 2017 12:12:06 -0700 (PDT)
Subject: Re: [PATCH v3 1/5] netlink: extended ACK reporting
To: David Miller <davem@davemloft.net>
References: <20170411173143.GA1899@salvia>
 <20170411.134225.398046538225438175.davem@davemloft.net>
 <cb6106f2-3128-da79-69bf-a10b249db054@cumulusnetworks.com>
 <20170411.150527.283014710949232666.davem@davemloft.net>
Cc: pablo@netfilter.org, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        jhs@mojatatu.com, jbenc@redhat.com, jiri@resnulli.us
From: David Ahern <dsa@cumulusnetworks.com>
Message-ID: <76edbeae-f050-092a-2b6a-01cb7d68cd36@cumulusnetworks.com> (sfid-20170411_211210_754008_7AB8D0E0)
Date: Tue, 11 Apr 2017 13:12:03 -0600
MIME-Version: 1.0
In-Reply-To: <20170411.150527.283014710949232666.davem@davemloft.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/11/17 1:05 PM, David Miller wrote:
> From: David Ahern <dsa@cumulusnetworks.com>
> Date: Tue, 11 Apr 2017 12:57:59 -0600
> 
>> On 4/11/17 11:42 AM, David Miller wrote:
>>> David, if you have a specific case where it's absolutely impossible
>>> to resolve this when the library is converted to support extended
>>> ACKs, please mention it.
>>
>> I don't have a specific library in mind. It is more the disjoint nature
>> of a socket option and message parsing, and thinking through the API.
> 
> Would you prefer it being passed via a control message at sendmsg()
> time?  That would require more changes to userland programs, and also
> increase the per-request overhead in the kernel as it parses this CMSG
> every single time.

Johannes' v4 adds a flag in the response that the parser can use to
definitely know the size of the errmsg.msg that was returned. That seems
sufficient to me. Did you disagree with that suggestion?
