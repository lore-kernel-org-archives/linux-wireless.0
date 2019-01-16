Return-Path: <SRS0=vb4L=PY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02E0FC43387
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 17:53:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB3DC20859
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 17:53:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aD4OeGVZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727278AbfAPRxf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 16 Jan 2019 12:53:35 -0500
Received: from mail-ot1-f52.google.com ([209.85.210.52]:38991 "EHLO
        mail-ot1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726754AbfAPRxe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Jan 2019 12:53:34 -0500
Received: by mail-ot1-f52.google.com with SMTP id n8so8517616otl.6
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jan 2019 09:53:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=+85w8dlR7AaHmcAY1sD09s9x1UxAayiTwWdlKnVYJAM=;
        b=aD4OeGVZ2Je1HEtQpTPySJsxGl35YcWl9H9mlez9Zi0gemAA888v8uMCf/NwNb+/ym
         cVfWC8qJ+wmrHiDIdRsRMOIvVTmtGLR1xxVo4GG2ce6wLIz0IHXSliF7OByxYJyo08NV
         yq05aRV31Yp8mOlS1WkWocLqq2wnpp84LeVyqPUX3EpZ4LvppC1duuROkgka0BkhW0I+
         CrGIJOcihbI3p1hClehP/IsIoLqSNCFrwb6hRVaIC0Ed9peGgoYjc4dQmwCrIF5OTDGx
         of2wGJR7i1hA0rwh8grypU9eQJp9cSbHFl7753/TDDY2N68q/AMv8BW2QZFTNO8njLT4
         uiTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=+85w8dlR7AaHmcAY1sD09s9x1UxAayiTwWdlKnVYJAM=;
        b=a2Aj7fqJTAtrzwljKP0kqYWdrC5BuH0t0GlYaPf+eMt/IsDpi6xxEIqMXuGcXmPpBT
         b2tZvXgqxTJSuO4uttKDbasSjEuF6VVbJAHSqoQV2ghhMFkCC+lBek7wkAjQ9DfzS05F
         mQHDKTYvwIs1948RpcflS4cGMnyZ0Eu+bPoioZhR1tI/8bFrVhgpmd2Ib4QWcP72oBIX
         KDI0fLWFT/VksmdUlZoYpfjV55DDTjZ2QV8AYIHpLFJMFimS2sYxpsn0ie2KmJB47oF5
         5OQuis+EJjb9GKgmTOVjT2673DwndWWvg/UJ0ed/uXZWmlFFGzIryRN1EaWWNvN72z0e
         Lt9A==
X-Gm-Message-State: AJcUukeBs+PoamEpL8KhuY38CuEIP4cG+j42BIpVHGsY+6A+xtVDLVK0
        Jm851uGS0/fm35crSVYElqDB8IQsik8tfzYf7SUCHMCk
X-Google-Smtp-Source: ALg8bN5XxyHqSOOmB9eBxvuvt8l26euIXXxixztwIRwormhfa5oxVvs3i2oUMbeTFKvyybNiJNYwCHrZVdg0sklw8VM=
X-Received: by 2002:a9d:620f:: with SMTP id g15mr6017093otj.296.1547661214042;
 Wed, 16 Jan 2019 09:53:34 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a9d:6c19:0:0:0:0:0 with HTTP; Wed, 16 Jan 2019 09:53:33
 -0800 (PST)
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Wed, 16 Jan 2019 18:53:33 +0100
Message-ID: <CAKR_QVLUcK2uNEAMXQszw7PPNt6=GHNfowQ9pXyJf13xvfU7sg@mail.gmail.com>
Subject: mailing list delivery failures
To:     linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

hi

checking archive of messages today at marc.info i noticed some missing
messages in my inbox, e.g this message from kees cook:
https://marc.info/?l=linux-wireless&m=154759697403620&w=2 was sent
2019-01-16 0:02:23, it shows up in my inbox at 18:11

and some messages did not even arrive, e.g
https://marc.info/?l=linux-wireless&m=154763819315242&w=2

is that some mailing list problems or what?
