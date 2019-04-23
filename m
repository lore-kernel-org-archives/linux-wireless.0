Return-Path: <SRS0=odSX=SZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19878C282E1
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 20:55:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7740218D3
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 20:55:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W1ggR+b8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727367AbfDWUzD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Apr 2019 16:55:03 -0400
Received: from mail-ot1-f52.google.com ([209.85.210.52]:33021 "EHLO
        mail-ot1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726339AbfDWUzD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Apr 2019 16:55:03 -0400
Received: by mail-ot1-f52.google.com with SMTP id j10so14169429otq.0
        for <linux-wireless@vger.kernel.org>; Tue, 23 Apr 2019 13:55:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:cc;
        bh=jV4L+mmXFkqmJPU3rBnTt6VfAI3WCqS3o+AsMCIXENs=;
        b=W1ggR+b8bphEymsuPQF9EByOgzM+JNq9Cj6vQy8SvENNp5TGE7DJZ0BfkEQlTMx7nR
         KlFj1JQDgO0WOcBOJklKewGg3pL3evXAkKB/zu+6S7g8RvXgY51LoqhkIv/Uk4uMwbN5
         ffnWUPc1om7PaJJPzBA00/rSvEq2geFrlDsAOED9JL/VcS9YYqXQaiIY5L0fdDPpYa0i
         haE0R1yL7vulnOB4tOJyS4ZffjrA4A4Bsr+ytUYQmVMy6jkq52U1dpJijXrQ9/7vtZqG
         pGydO+zsGGQMdsncz9WoYgRV32S8xcqqUPfMlQ4Z1BRnk4uS+HapfjwYx/iUOhQAHrAl
         fSaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:cc;
        bh=jV4L+mmXFkqmJPU3rBnTt6VfAI3WCqS3o+AsMCIXENs=;
        b=s3e4w68cbez+dglMBq8zuKOD40KJ55vmfIFyODRzGAeL/4KTgWz2OKxJ8xJk/W4e1z
         YFSLQI461cCrMOrHF8gK4S1KAkc+Uc41HGxx+FC2myY0vE7zhig0BNaFoWBd6kLXtI7g
         lJUQMiyIT+DwG+f7w11QcwyqxLJRUmI710KrTucV2wYxB4uwRhbVWuhefPfWXWsJwn3E
         uqI93rXAKVVwZx3HaAXgX9BMUpbNdGqyM5dSbdzxtRCyM3j8LKWLva3PfHZvo/zDeqt8
         g44Ho3WpP11eF6leP8kR/yt+PGUoGMylG0M5RlqkPfKjSnW6S8EO5oY/uvBcyQyr+aht
         UkNw==
X-Gm-Message-State: APjAAAVavrtqVKh46DNa0rXgoLIKdRsCRrTFc5S+hjdSB8zgWdPyGtVa
        F0fYrc6omhmjO9MLBVDporhARy1XT0wn9yOURQxT4z0S
X-Received: by 2002:a9d:e8f:: with SMTP id 15mt17223496otj.148.1556052901917;
 Tue, 23 Apr 2019 13:55:01 -0700 (PDT)
MIME-Version: 1.0
References: <1553711659-27600-1-git-send-email-peter.oh@bowerswilkins.com>
 <20190408124159.GC15126@ubuntu-xps13> <af4d49d9-fc9e-ebe3-20ab-edef6c12a2eb@bowerswilkins.com>
In-Reply-To: <af4d49d9-fc9e-ebe3-20ab-edef6c12a2eb@bowerswilkins.com>
From:   b.K.il.h.u+tigbuh@gmail.com
Date:   Tue, 23 Apr 2019 22:54:50 +0200
Message-ID: <CAPuHQ=Grm6fEdP95jfj4zEXCr8be0PMOb9iv3oeYUt0y2Oeshw@mail.gmail.com>
Subject: Re: [wireless-regdb] [PATCH] wireless-regdb: Update regulatory rules
 for South Korea
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "wireless-regdb@lists.infradead.org" 
        <wireless-regdb@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Could you please convert the document in question to a more open
format so we could try machine translation on it? ODT, HTML, docx and
PDF would probably work as long as copy & pasting is enabled.

I found 1 offline and 2 online viewers, not sure which one works:
https://www.hancom.com/global/cs_center/csDownload.do
https://store.thinkfree.com/en/join
https://nid.naver.com/user2/V2Join.nhn?m=agree&lang=en_US&cpno=

The trial editor may also support exporting.

On Mon, Apr 22, 2019 at 8:05 PM Peter Oh <peter.oh@bowerswilkins.com> wrote:
> On 04/08/2019 05:41 AM, Seth Forshee wrote:
> > On Wed, Mar 27, 2019 at 06:34:29PM +0000, Peter Oh wrote:
> >> From: Peter Oh <peter.oh@bowerswilkins.com>
> >>
> >> Update power limit as documented in:
> >> https://www.rra.go.kr/FileDownSvl?file_type=LAWKR&file_parentseq=54&file_seq=27
> >> which revised on November 30, 2016.
> >>
> >> Signed-off-by: Peter Oh <peter.oh@bowerswilkins.com>
> > I usually try to check the changes against the documents, but in this
> > case I haven't been able to get any English tranlation for the document
> > (or even view the contents it in any meaningful way). I don't suppose
> > you know where to find an English version of the document?
> Unfortunately there is no English version of the doc. Typically I use
> Google translation to understand foreign language, but in this case I
> contacted that department personally via phone call and directed to the
> doc by the responsible person from the department.
>
> Thanks,
> Peter
