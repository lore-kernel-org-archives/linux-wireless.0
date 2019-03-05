Return-Path: <SRS0=e8Py=RI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F4DBC4360F
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Mar 2019 08:37:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E28EA2082C
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Mar 2019 08:37:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727327AbfCEIhh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 5 Mar 2019 03:37:37 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:39147 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbfCEIhh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Mar 2019 03:37:37 -0500
Received: by mail-qt1-f193.google.com with SMTP id o6so8161352qtk.6;
        Tue, 05 Mar 2019 00:37:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Tnxnpf8kZGLiuVVHIrOVQ0i6UzbMU+wg4g+ni8NrgX0=;
        b=I+u51rCzqLTUtlcOck4FuxmhcHZIttVACAJrxlacdIDN1dsRXgTlIztus/xj4SKrsP
         PRtYXZREauVXrNTwjNhRFst8edeurp997+fAtw8IChx7oEEYN0/M8xm53P4SHJPejYbl
         fC3BezjrwXD/1d6x+RfGppQd0PaV22oCcKJvJDHjAw0oeI5jpNZDIjbRUO+MFSIZczYy
         eILnmqWzRa4ynka7V8kifE7F4cUfJ/zVFT0/kPsZdnuNs5SzYrGiLcWsKsH22/+6TBJz
         TnNsHHBPNPeWiZKzPGyIKTAZes6lMZw19WfEZcjvyjCfzM793CgwfoINVrX+HY4iN+R1
         mzoA==
X-Gm-Message-State: APjAAAX4JzVhjgtH01mwCLIVIbRr8V6eIUsJqfTjj8GvHCPElpVHCsCh
        /AYnBDZ2I+PVDLX6e0QsXd49qnr6ssz2IpcUjVw=
X-Google-Smtp-Source: APXvYqx6K6Vl8MPjob+tIas8+HkU2jqa8boSAVFD1SP3GUddIF+PzfNcNEvI6J08dmi/hYi09EH1UCRaHheVPoCmBbs=
X-Received: by 2002:a0c:b758:: with SMTP id q24mr1160498qve.149.1551775056617;
 Tue, 05 Mar 2019 00:37:36 -0800 (PST)
MIME-Version: 1.0
References: <20190304203924.2111146-1-arnd@arndb.de> <ec4e92fa787a7db1caf39920a62c3721849baee9.camel@intel.com>
In-Reply-To: <ec4e92fa787a7db1caf39920a62c3721849baee9.camel@intel.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 5 Mar 2019 09:37:20 +0100
Message-ID: <CAK8P3a3ziTxhEW5ea828jNjktR9qH-T2OknON5RVBrbiXT4kBw@mail.gmail.com>
Subject: Re: [PATCH] iwlwifi: fix 64-bit division
To:     Luciano Coelho <luciano.coelho@intel.com>
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Avraham Stern <avraham.stern@intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Mar 5, 2019 at 7:44 AM Luciano Coelho <luciano.coelho@intel.com> wrote:
> On Mon, 2019-03-04 at 21:38 +0100, Arnd Bergmann wrote:
> This was already fixed with this patch:
>
> https://patchwork.kernel.org/patch/10823267/
>
> ...but it hasn't reached the mainline yet.
>
> I'm planning to send it to the v5.1-rc series as soon as the merge
> window closes.  Is that quick enough for you?

That's fine, I just want it to reach 5.1 so it does not regress against 5.0.

Sorry for the slightly bad timing of my submission. I had just restarted
my randconfig tests the other day and wanted to get my 60 new patches
out as quickly as possible.

       Arnd
